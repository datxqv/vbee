//
//  UITextFieldExtension.swift
//  Visunite
//
//  Created by Quan Nguyen on 2/11/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit

extension UITextField {
    
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

@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
    }
}
