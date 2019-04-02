//
//  TypeView.swift
//  VBee
//
//  Created by daicashigeru on 4/23/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

class TypeModel: NSObject {
    
    var imageName: String = ""
    var name: String = ""
    var id: Int = 0
    
    // Convinient init
    convenience init(imageName: String, name: String, id: Int = 0) {
        
        self.init()
        self.imageName = imageName
        self.name = name
    }
    
    class func allType() -> [TypeModel]{
        let arrayType = [TypeModel(imageName: "pet_128", name: "Thú cưng"), TypeModel(imageName: "key_128", name: "Chìa khoá"),TypeModel(imageName: "icon_tui_128", name: "Túi đựng")]
        
        for i in 0..<arrayType.count {
            
            let element = arrayType[i]
            element.id = i + 1
        }
        
        return arrayType
    }
    
    class func modelWith(id: Int) -> TypeModel {
        let allType = TypeModel.allType()
        for type in allType {
            if type.id == id {
                return type
            }
        }
        
        return allType[0]
    }
}

class TypeView: UIView {

    // MARK: - Variable and IBOutlet
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var nameLabel: UILabel!

    // Custom init
    class func initWith(model: TypeModel) -> TypeView {
        let view = Bundle.main.loadNibNamed("TypeView", owner: self, options: nil)!.first as? TypeView
        view?.imageView?.image = UIImage(named: model.imageName)
        view?.nameLabel.text = model.name
        
        return view!
    }
    
}
