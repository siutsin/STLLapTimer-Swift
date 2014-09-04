//
//  Utility.swift
//  LapTimer-Swift
//
//  Created by Simon Li on 4/9/14.
//  Copyright (c) 2014 Simon Li. All rights reserved.
//

import UIKit

class Utility: NSObject
{
    /*!
    *  http://stackoverflow.com/a/24318861/837059
    */
    class func delay(delay:NSTimeInterval, closure:()->())
    {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    /*!
    *  http://stackoverflow.com/a/25120393/837059
    */
    typealias dispatch_cancelable_closure = (cancel : Bool) -> ()
    class func cancelableDelay(time:NSTimeInterval, closure:()->()) ->  dispatch_cancelable_closure? {
        
        func dispatch_later(clsr:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), clsr)
        }
        
        var closure:dispatch_block_t? = closure
        var cancelableClosure:dispatch_cancelable_closure?
        
        let delayedClosure:dispatch_cancelable_closure = { cancel in
            if let clsr = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), clsr);
                }
            }
            closure = nil
            cancelableClosure = nil
        }
        
        cancelableClosure = delayedClosure
        
        dispatch_later {
            if let delayedClosure = cancelableClosure {
                delayedClosure(cancel: false)
            }
        }
        return cancelableClosure;
    }
    
    class func cancelDelay(closure:dispatch_cancelable_closure?)
    {
        if closure != nil { closure!(cancel: true) }
    }
}
