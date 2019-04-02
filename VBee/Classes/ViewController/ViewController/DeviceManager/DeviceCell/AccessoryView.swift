//
//  AccessoryView.swift
//  VBee
//
//  Created by daicashigeru on 5/1/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit


class AccessoryView: UIView {
    @IBOutlet var imageView: UIImageView!

    class func getInstance(imageNamed: String) -> AccessoryView {
        
        let view = Bundle.main.loadNibNamed("AccessoryView", owner: self, options: nil)?.first as! AccessoryView
        view.imageView.image = UIImage(named: imageNamed)
        return view
    }
    
    // MARK: - Action
    @IBAction func ringingButtonDidClicked(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonDidClicked(_ sender: Any) {
        
        
    }
    
}
