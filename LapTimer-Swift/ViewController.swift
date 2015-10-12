//
//  ViewController.swift
//  LapTimer-Swift
//
//  Created by Simon Li on 3/9/14.
//  Copyright (c) 2014 Simon Li. All rights reserved.
//

import UIKit

class ViewController: UITableViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet weak var filterView: GPUImageView!
    @IBOutlet weak var titleTimerLabel: UILabel!
    
    // MARK: - Variables / Constants
    
    let sensitivity: CGFloat = 0.1
    let cooldownPeriod = 2.0
    
    var startTime: NSDate! = NSDate()
    var cooldown = false
    var lapCounter: NSInteger = 0
    var lapTimeArray = [String]()
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let camera = self.videoCamera {
            camera.startCameraCapture()
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.timer.fire()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        if let camera = self.videoCamera {
            camera.stopCameraCapture()
        }
        self.timer.invalidate()
        super.viewDidDisappear(animated)
    }

    // MARK: - Motion Detector
    
    lazy var videoCamera: GPUImageVideoCamera? =
    {
        // Simulator will return nil
        if let tempVideoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPreset352x288, cameraPosition: .Back) {
            tempVideoCamera.outputImageOrientation = .Portrait
            var filter = GPUImageMotionDetector()
            filter.motionDetectionBlock =
                {
                    [unowned self]
                    (CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) -> Void in
                    if (motionIntensity > self.sensitivity)
                    {
                        self.lap()
                    }
            }
            tempVideoCamera.addTarget(filter)
            tempVideoCamera.addTarget(self.filterView)
            return tempVideoCamera
        }
        return nil
    }()
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        if let camera = self.videoCamera {
            // FIXME: Orientation bug?
            switch UIDevice.currentDevice().orientation
            {
            case UIDeviceOrientation.Portrait:
                camera.outputImageOrientation = UIInterfaceOrientation.Portrait
            case UIDeviceOrientation.PortraitUpsideDown:
                camera.outputImageOrientation = UIInterfaceOrientation.PortraitUpsideDown
            case UIDeviceOrientation.LandscapeLeft:
                camera.outputImageOrientation = UIInterfaceOrientation.LandscapeRight
            case UIDeviceOrientation.LandscapeRight:
                camera.outputImageOrientation = UIInterfaceOrientation.LandscapeLeft
            default:
                NSLog("Orientation error")
            }
        }
    }
    
    // MARK: - Lap Timer
    
    @IBAction func didClickReset(sender: AnyObject)
    {
        self.lapTimeArray.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        self.cooldown = false
        self.lapCounter = 0
        self.startTime = nil
        self.lap()
    }
    
    func lap()
    {
        if (self.cooldown) { return }
        
        self.cooldown = true
        Utility.delay(self.cooldownPeriod, closure:
        {
            [unowned self]
            () -> () in
            self.cooldown = false
        })
        
        if (self.startTime == nil)
        {
            self.startTime = NSDate()
        }
        else
        {
            self.lapCounter++
            let interval = NSDate().timeIntervalSinceDate(self.startTime!)
            self.startTime = NSDate()
            self.lapTimeArray.insert(self.stringFromTimeInterval(interval), atIndex: 0)
            dispatch_async(dispatch_get_main_queue(),
            {
                [unowned self]
                () -> Void in
                let indexPath = NSIndexPath(forRow:0, inSection:0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }
    }
    
    lazy var timer: NSTimer =
    {
        var tempTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        return tempTimer
    }()

    func updateTimer()
    {
        let interval = NSDate().timeIntervalSinceDate(self.startTime!)
        let timeUnits = self.timeUnitsForInterval(interval)
        let minutes = NSString(format:"%02d", timeUnits["minutes"]!)
        let seconds = NSString(format:"%02d", timeUnits["seconds"]!)
        let centiseconds = NSString(format:"%02d", timeUnits["centiseconds"]!)
        let titleString = "\(minutes):\(seconds):\(centiseconds)"
        dispatch_async(dispatch_get_main_queue(),
        {
            [unowned self]
            () -> Void in
            self.titleTimerLabel.text = titleString
        })
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String
    {
        let timeUnits = self.timeUnitsForInterval(interval)
        let minutes = NSString(format:"%02d", timeUnits["minutes"]!)
        let seconds = NSString(format:"%02d", timeUnits["seconds"]!)
        let centiseconds = NSString(format:"%02d", timeUnits["centiseconds"]!)
        return "Lap: \(self.lapCounter) Time: \(minutes):\(seconds):\(centiseconds)"
    }
    
    func timeUnitsForInterval(interval: NSTimeInterval) -> Dictionary<String, Int>
    {
        let ti: Double = Double(interval)
        let minutes: Int = (Int(ti) / 60) % 60
        let seconds: Int = Int(ti) % 60
        let centiseconds: Int = Int(round(fmod(ti, 1) * 100))
        let timeUnits: [String: Int] = ["minutes": minutes, "seconds": seconds, "centiseconds": centiseconds]
        return timeUnits
    }
    
    // MARK: - UITableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.lapTimeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        cell!.textLabel!.text = self.lapTimeArray.count > 0 ? self.lapTimeArray[indexPath.row] : ""
        return cell!
    }
}

