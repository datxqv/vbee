//
//  VImageView.swift
//  Visunite
//
//  Created by datxqv on 3/9/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit

@IBDesignable
class VImageView: UIImageView {
    
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
    
}

