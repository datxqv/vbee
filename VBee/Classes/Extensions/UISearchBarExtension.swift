//
//  UISearchBarExtension.swift
//  Visunite
//
//  Created by quanarmy on 01/22/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    open override func awakeFromNib() {
        self.customView()
    }
    
    func customView() {
        if let textField = self.textField {
            textField.showHideKeyboard()
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.cornerRadius = 15
        }
    }
    
    var textField: UITextField? {
        
        func findInView(_ view: UIView) -> UITextField? {
            for subview in view.subviews {
                print("checking \(subview)")
                if let textField = subview as? UITextField {
                    return textField
                }
                else if let v = findInView(subview) {
                    return v
                }
            }
            return nil
        }
        
        return findInView(self)
    }
    
    var iconImage: UIImageView? {
        
        func findInView(_ view: UIView) -> UIImageView? {
            for subview in view.subviews {
                print("checking \(subview)")
                if let icon = subview as? UIImageView {
                    return icon
                }
                else if let v = findInView(subview) {
                    return v
                }
            }
            return nil
        }
        
        return findInView(self)
    }

}
