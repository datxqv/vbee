//
//  DQTextField.swift
//  DQ_User
//
//  Created by Gio Viet on 2/17/17.
//  Copyright © 2017 Paditech Inc. All rights reserved.
//

import UIKit

@IBDesignable

class VTextField: UITextField {

    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateButtomLineLayout()
        
        if self.cornerCircle {
            layer.cornerRadius = self.frame.height * 0.5
        }
    }
    
    @IBInspectable var myPlaceholder: String = "" {
        didSet {
            let attributes = [
                NSFontAttributeName : self.font as Any,
                NSForegroundColorAttributeName : self.textColor as Any
            ]
            self.attributedPlaceholder = NSAttributedString(string: myPlaceholder, attributes: attributes)
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            setNeedsDisplay()
        }
    }

    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.height * 0.5
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
                //self.bottomLine?.borderColor = DQDefined.lightBlueColor().cgColor
                self.bottomLine?.borderWidth = bottomLineHeight
                self.layer.addSublayer(self.bottomLine!)
            }
            
            self.updateButtomLineLayout()
        }
    }
    
    func updateButtomLineLayout() {
        if let line = self.bottomLine {
            let lineHeight = bottomLineHeight
            line.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        }
    }
    
    /*
     override func draw(_ rect: CGRect) {
     
     let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
     let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
     
     let path = UIBezierPath()
     
     path.move(to: startingPoint)
     path.addLine(to: endingPoint)
     path.lineWidth = 1.5
     
     DQDefined.lightBlueColor().setStroke()
     
     path.stroke()
     }
     */
}
