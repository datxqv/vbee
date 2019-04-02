//
//  DQLabel.swift
//  DQ_User
//
//  Created by Gio Viet on 2/20/17.
//  Copyright © 2017 Paditech Inc. All rights reserved.
//

import UIKit

@IBDesignable

class VLabel: UILabel {

    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateButtomLineLayout()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
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
