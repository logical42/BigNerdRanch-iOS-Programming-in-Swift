//
//  BNRDrawView.swift
//  TouchTracker
//
//  Created by Han Kang on 6/12/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDrawView: UIView {
    var linesInProgress = NSMutableDictionary()
    var finishedLines = BNRLine[]()
    init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.multipleTouchEnabled = true
    }
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().set()
        for line in self.finishedLines {
            self.strokeLine(line)
        }
        // hack since iteration in swift doesn't seem to handle 
        // all enumerable types just yet
        let keys = self.linesInProgress.allKeys as NSValue[]
        for key in keys {
            self.strokeLine(self.linesInProgress[key] as BNRLine)
        }
    }
    
    func strokeLine(line:BNRLine) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 10
        bezierPath.lineCapStyle = kCGLineCapRound
        bezierPath.moveToPoint(line.begin!)
        bezierPath.addLineToPoint(line.end!)
        bezierPath.stroke()
    }
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)  {
        // hack since iteration in swift doesn't seem to handle
        // all enumerable types just yet
        let arrayOfTouches = touches.allObjects as UITouch[]
        for touch in arrayOfTouches {
            let location = touch.locationInView(self)
            let line = BNRLine()
            line.begin = location
            line.end = location
            let key = NSValue(nonretainedObject:touch)
            self.linesInProgress[key] = line
        }
        self.setNeedsDisplay()
    }
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        // hack since iteration in swift doesn't seem to handle
        // all enumerable types just yet
        let arrayOfTouches = touches.allObjects as UITouch[]
        for touch in arrayOfTouches {
            let key = NSValue(nonretainedObject:touch)
            let line = self.linesInProgress[key] as BNRLine
            line.end = touch.locationInView(self)
        }
        self.setNeedsDisplay()
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        // hack since iteration in swift doesn't seem to handle
        // all enumerable types just yet
        let arrayOfTouches = touches.allObjects as UITouch[]
        for touch in arrayOfTouches {
            let key = NSValue(nonretainedObject:touch)
            let line = self.linesInProgress[key] as BNRLine
            self.finishedLines.append(line)
            self.linesInProgress.removeObjectForKey(key)
        }
        self.setNeedsDisplay()
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        // hack since iteration in swift doesn't seem to handle
        // all enumerable types just yet
        let arrayOfTouches = touches.allObjects as UITouch[]
        for touch in arrayOfTouches {
            let key = NSValue(nonretainedObject:touch)
            self.linesInProgress.removeObjectForKey(key)
        }
        self.setNeedsDisplay()
    }
}
