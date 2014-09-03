//
//  ViewController.swift
//  LapTimer-Swift
//
//  Created by Simon Li on 3/9/14.
//  Copyright (c) 2014 Simon Li. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UITableViewController
{
    // MARK: - IBOutlet
    
    @IBOutlet weak var filterView: GPUImageView!
    @IBOutlet weak var titleTimerLabel: UILabel!
    
    // MARK: - Variables / Constants
    
    let sensitivity = 0.2
    let cooldownPeriod = 2.0
    
    var startTime: NSDate?
    var timer: NSTimer?
    var cooldown = false
    var lapCounter: NSInteger = 0
    var lapTimeArray = [String]()
    
    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.videoCamera.startCameraCapture()
    }

    // MARK: - Motion Detector
    
    lazy var videoCamera: GPUImageVideoCamera =
    {
        var tempVideoCamera = GPUImageVideoCamera(sessionPreset: (AVCaptureSessionPreset352x288 as String), cameraPosition: AVCaptureDevicePosition.Back)
        tempVideoCamera.outputImageOrientation = UIApplication.sharedApplication().statusBarOrientation
        var filter = GPUImageMotionDetector()
        filter.motionDetectionBlock = { (CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) -> Void in
            if (motionIntensity > 0.2) {
                self.lap()
            }
        }
        tempVideoCamera.addTarget(filter)
        tempVideoCamera.addTarget(self.filterView)
        return tempVideoCamera
    }()
    
    // MARK: - Lap Timer
    
    func lap() {
        //
    }
    
    // MARK: - UITableView
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.lapTimeArray.count
    }
    
//    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
//        var cell = tableView?.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
//        cell!.textLabel.text = self.lapTimeArray.count > 0 ? self.lapTimeArray[indexPath.row] : ""
//        return cell
//    }
    
//    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
//        var cell = tableView?.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
//        cell!.textLabel.text = self.lapTimeArray.count > 0 ? self.lapTimeArray[indexPath.row] : ""
//        return cell
//    }

}

