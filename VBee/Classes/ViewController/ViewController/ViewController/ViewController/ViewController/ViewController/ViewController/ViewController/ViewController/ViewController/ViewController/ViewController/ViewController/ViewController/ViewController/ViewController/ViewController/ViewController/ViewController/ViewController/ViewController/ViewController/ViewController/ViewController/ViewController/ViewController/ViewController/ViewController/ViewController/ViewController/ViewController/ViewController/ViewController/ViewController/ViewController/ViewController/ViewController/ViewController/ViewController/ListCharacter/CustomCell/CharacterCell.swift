//
//  CharacterCell.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth

class CharacterCell: UITableViewCell {

    @IBOutlet weak var charaterNameLabel: UILabel!
    
    @IBOutlet weak var uuidLabel: UILabel!
    
    @IBOutlet weak var propertyLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Fill data
    func fillData(charaterName: String, character: CBCharacteristic) {
        
        self.charaterNameLabel.text = charaterName
        self.uuidLabel.text = character.uuid.uuidString
        self.propertyLabel.text = character.permissonDescription()
        
        let data = character.value as? NSData
        
        if let dataReal = data {
            var value: UInt8 = 0
            dataReal.getBytes(&value, length:  MemoryLayout<UInt8>.size)
            self.valueLabel.text = "Value:" + "\(value)"
        } else {
            
            self.valueLabel.text = "Value:" + "empty"
        }
    }
    
}
