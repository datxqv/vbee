//
//  PeripheralCell.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var macLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fillData(name: "", macAddress: "", uuid: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(name: String? = "", macAddress: String? = "", uuid: String? = "") {
        
        self.labelName.text = name
        self.macLabel.text = "Mac : " + macAddress!
        self.uuidLabel.text = "UUID: " + uuid!
    }
    
    func fillData(data: CBPeripheralData? = CBPeripheralData()) {
        
        self.labelName.text = data?.deviceName
        self.uuidLabel.text = "UUID: " + (data?.uuid)!
        self.macLabel.text = "MAC: " + (data?.macAddress)!
        
        if data?.connectAble == true {
            self.backgroundColor = UIColor.white
            
        }
        
        if data?.connected == true {
            self.backgroundColor = UIColor.green
        }
    }
}
