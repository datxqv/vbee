//
//  UINavigationBarExtention.swift
//  Visunite
//
//  Created by luckymanbk on 8/31/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setBottomBorderColor(_ color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
