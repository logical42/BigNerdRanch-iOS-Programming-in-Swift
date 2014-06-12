//
//  BNRDrawView.swift
//  TouchTracker
//
//  Created by Han Kang on 6/12/14.
//  Copyright (c) 2014 LinkedIn. All rights reserved.
//

import UIKit

class BNRDrawView: UIView {
    var currentLine:BNRLine?
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
        if self.currentLine {
            UIColor.redColor().set()
            self.strokeLine(self.currentLine!)
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
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInView(self)
        let newCurrentLine = BNRLine()
        newCurrentLine.begin = location
        newCurrentLine.end = location
        self.currentLine = newCurrentLine
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInView(self)
        if self.currentLine {
            self.currentLine!.end = location
        }
        self.setNeedsDisplay()
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        if self.currentLine {
            self.finishedLines.append(self.currentLine!)
        }
        self.currentLine = nil
        self.setNeedsDisplay()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
