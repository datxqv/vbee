//
//  DQView.swift
//  DQ_User
//
//  Created by datxqv on 2/23/17.
//  Copyright © 2017 Paditech Inc. All rights reserved.
//

import UIKit

@IBDesignable
class VView: UIView {
    
     @IBInspectable var radius: CGFloat = 10.0 {
        
        didSet {
            
            var deltaX: CGFloat = 20.0
            let path = CGMutablePath()
            while deltaX + 2*radius < self.frame.size.width {
                
                
                path.addArc(center: CGPoint(x: deltaX, y: -radius), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
                deltaX = deltaX + 2*radius + 20
            }
            path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
            
            let maskLayer = CAShapeLayer()
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            self.layer.mask = maskLayer
            self.clipsToBounds = true
            
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            self.layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            self.layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorOpacity: CGFloat = 0 {
        
        didSet {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(colorOpacity)
            setNeedsDisplay()
        }
    }
}

extension UIView {
    
    internal func createOval(radius: CGFloat, startPosition: CGFloat = 20.0, distance: CGFloat = 20.0) {
        
        var deltaX: CGFloat = startPosition
        let path = CGMutablePath()
        
        while deltaX < self.frame.size.width {
            
            path.addArc(center: CGPoint(x: deltaX, y: 0), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
            deltaX = deltaX + 2*radius + distance
        }
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        self.layer.mask = maskLayer
        self.clipsToBounds = true
        
        setNeedsDisplay()
    }
}

extension UIView {
    
    internal func makeCorner(radius: CGFloat, borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        self.layer.masksToBounds = radius > 0
    }
    
    internal func makeRound(borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        self.makeCorner(radius: 0.5 * self.frame.height, borderWidth: borderWidth, borderColor: borderColor)
    }
}
