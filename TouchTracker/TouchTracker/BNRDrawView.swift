//
//  BNRDrawView.swift
//  TouchTracker
//
//  Created by Han Kang on 6/12/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDrawView: UIView, UIGestureRecognizerDelegate {
    var linesInProgress = NSMutableDictionary()
    var finishedLines = BNRLine[]()
    var selectedLine:BNRLine?
    var moveRecognizer:UIPanGestureRecognizer?

    init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        self.multipleTouchEnabled = true
        
        // add gesture recognizers
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        self.addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tap:")
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        self.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        
        
        let mRecognizer = UIPanGestureRecognizer(target: self, action: "moveLine:")
        mRecognizer.delegate = self
        mRecognizer.cancelsTouchesInView = false
        self.moveRecognizer = mRecognizer
        self.addGestureRecognizer(self.moveRecognizer!)
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
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        let moveGestureRecognizer = self.moveRecognizer!
        if gestureRecognizer == moveGestureRecognizer {
            return true
        }
        return false
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
    func longPress(gestureRecognizer:UIGestureRecognizer) {
        NSLog("FIRED longPress")
        let point = gestureRecognizer.locationInView(self)
        self.selectedLine = self.lineAtPoint(point)
        // a bit hacky and deviates from the book here
        // but this is because the state returned by the swift object seems 
        // to be invalid
        if self.selectedLine {
            NSLog("Found selected line")
            self.linesInProgress.removeAllObjects()
        } else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            self.selectedLine = nil
        }
        self.setNeedsDisplay()
    }
    func moveLine(gestureRecognizer:UIPanGestureRecognizer) {
        if !self.selectedLine {
            return
        }
        if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            let translation = gestureRecognizer.translationInView(self)
            var start = self.selectedLine!.begin!
            var end = self.selectedLine!.end!
            start.x += translation.x
            start.y += translation.y
            end.x += translation.x
            end.y += translation.y
            self.selectedLine!.begin = start
            self.selectedLine!.end = end
            self.setNeedsDisplay()
            gestureRecognizer.setTranslation(CGPointZero, inView: self)
        }
    }
}
