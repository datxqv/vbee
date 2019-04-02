//
//  TableViewExtension.swift
//  LaleTore
//
//  Created by luckymanbk on 11/24/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

public let kTagIndicatorView = 999999
public let kYPosition = CGFloat(44)

extension UITableView {
    
//    func addLabel(_ title: String) {
//        if self.viewWithTag(kTagLabel) == nil {
//            let font = FontsHelper.fontHelvetica(ofSize: 15)
//            let height = title.stringHeightWithMaxWidth(self.width, font: font)
//            let label = ECusstomLabel(frame: CGRect(x: 15, y: kYPosition, width: UIScreen.width - 30, height: height + 40))
//            label.tag = kTagLabel
//            label.backgroundColor = UIColor.clear
//            label.textColor = UIColor.colorFromHexString("#b5b5b5")
//            label.text = title
//            label.font = font
//            label.numberOfLines = 0
//            label.textAlignment = .center
//            self.addSubview(label)
//        }
//    }
    
    func removeLabel() {
        self.subviews.forEach {
            $0.viewWithTag(kTagLabel)?.removeFromSuperview()
        }
    }
    
    func addIndicatorView(style: UIActivityIndicatorViewStyle) {
        if self.viewWithTag(kTagIndicatorView) == nil {
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: style)
            activityIndicatorView.center = self.center
            activityIndicatorView.tag = kTagIndicatorView
            activityIndicatorView.startAnimating()
            self.addSubview(activityIndicatorView)
        }
    }
    
    func removeIndicatorView() {
        self.subviews.forEach {
            $0.viewWithTag(kTagIndicatorView)?.removeFromSuperview()
        }
    }
    
    func hideORShowVerticalScrollIndicator() {
        let contentHeight = self.contentSize.height
        let averageHeightRow = contentHeight / CGFloat(self.numberOfRows(inSection: 0))
        if contentHeight - averageHeightRow < UIScreen.height - CGFloat(64 + 44 + 49) {
            self.showsVerticalScrollIndicator = false
        } else {
            self.showsVerticalScrollIndicator = true
        }
    }
}
