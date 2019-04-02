//
//  UILabelExtension.swift
//  Visunite
//
//  Created by luckymanbk on 8/30/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

extension UILabel {
    
    func contentSize() -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        let attributes: [String: AnyObject] = [NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraphStyle]
        let contentSize: CGSize = self.text!.boundingRect(
            with: self.frame.size,
            options: ([.usesLineFragmentOrigin, .usesFontLeading]),
            attributes: attributes,
            context: nil
            ).size
        return contentSize
    }
    
    func heightWithMaxWidth(_ maxWidth: CGFloat) -> CGFloat {
        let attributes: [String: AnyObject] = [NSFontAttributeName: self.font]
        let size: CGSize = self.text!.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        
        return size.height
    }
    
    func setFrameWithWidth(_ width: CGFloat) {
        self.numberOfLines = 0
        let attributes: [String: AnyObject] = [NSFontAttributeName: self.font]
        
        let resultSize: CGSize = self.text!.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        let resultHeight: CGFloat = resultSize.height
        let resultWidth: CGFloat = resultSize.width
        var frame: CGRect = self.frame
        frame.size.height = resultHeight
        frame.size.width = resultWidth
        self.frame = frame
    }
    
    func htmlEncodedString() {
        let encodedData = self.text!.data(using: String.Encoding.utf8)!
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8 as AnyObject
        ]
        
        do {
            let attributeString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self.attributedText = attributeString
        }
    }
    
    func setTextWithStroke(textColor: UIColor, strokeColor: UIColor, text: String) {
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : textColor,
            NSForegroundColorAttributeName : strokeColor,
            NSStrokeWidthAttributeName : -3.0
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
    }
}

@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
