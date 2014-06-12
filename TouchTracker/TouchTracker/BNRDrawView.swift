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
    var selectedLine:BNRLine?
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.multipleTouchEnabled = true
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTapRecognizer)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
    }
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().set()
        for line in self.finishedLines {
            self.strokeLine(line)
        }
        // hack since iteration in swift doesn't seem to handle 
        // all enumerable types just yet
        let lineKeys = self.linesInProgress.allKeys as NSValue[]
        
        for lineKey in lineKeys {
            self.strokeLine(self.linesInProgress[lineKey] as BNRLine)
        }
        if self.selectedLine {
            UIColor.greenColor().set()
            self.strokeLine(self.selectedLine!)
        }
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
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    func strokeLine(line:BNRLine) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = 10
        bezierPath.lineCapStyle = kCGLineCapRound
        bezierPath.moveToPoint(line.begin!)
        bezierPath.addLineToPoint(line.end!)
        bezierPath.stroke()
    }
    func lineAtPoint(point:CGPoint) -> BNRLine? {
        for line in self.finishedLines {
            let start = line.begin!
            let end = line.end!
            for (var t=0.0;t<=1.0;t+=0.05) {
                let x = start.x + t * (end.x - start.y)
                let y = start.y + t * (end.y - start.y)
                if hypot(x - point.x, y - point.y) < 20 {
                    return line
                }
            }
        }
        return nil
    }
    func doubleTap(gestureRecognizer:UIGestureRecognizer) {
        NSLog("Recognized DOUBLE TAP")
        self.linesInProgress.removeAllObjects()
        self.finishedLines.removeAll()
        self.setNeedsDisplay()
    }
    func tap(gestureRecognizer:UIGestureRecognizer) {
        NSLog("Recognized TAP")
        let point = gestureRecognizer.locationInView(self)
        self.selectedLine = self.lineAtPoint(point)
        if self.selectedLine {
            self.becomeFirstResponder()
            let menu = UIMenuController.sharedMenuController()
            let deleteItem = UIMenuItem(title: "Delete", action: "deleteLine:")
            menu.menuItems = [deleteItem]
            menu.setTargetRect(CGRectMake(point.x, point.y, 2, 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        }
        else {
            UIMenuController.sharedMenuController().setMenuVisible(false, animated: true)
        }
        self.setNeedsDisplay()
    }
    func deleteLine(sender:AnyObject?) {
        NSLog("FIRED DELETE")
        let objectiveArray = self.finishedLines as NSArray
        let index = objectiveArray.indexOfObject(self.selectedLine!)
        self.finishedLines.removeAtIndex(index)
        self.setNeedsDisplay()
    }
}
