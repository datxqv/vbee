//
//  UITextViewExtension.swift
//  Visunite
//
//  Created by Quan Nguyen on 2/11/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit

extension UITextView {
    
    open override func awakeFromNib() {
        //self.showHideKeyboard()
    }
    
    func showHideKeyboard() {
        
        //Declared at top of view controller
        var accessoryDoneButton: UIBarButtonItem!
        let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        //Configured in viewDidLoad()
        let flex1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: #selector(self.hideKeyboard))
        accessoryDoneButton = UIBarButtonItem(image: UIImage(named: "hide_keyboard"), style: .plain, target: self, action: #selector(self.hideKeyboard))
        accessoryDoneButton.tintColor = UIColor.black
        let flex2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: #selector(self.hideKeyboard))
        accessoryToolBar.items = [flex1, accessoryDoneButton, flex2]
        self.inputAccessoryView = accessoryToolBar
    }
    
    
    @objc private func hideKeyboard() {
        self.resignFirstResponder()
    }
}


extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
