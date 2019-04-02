//
//  ServiceCell.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    
    @IBOutlet weak var uuidService: UILabel!
    @IBOutlet weak var piorityService: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(name: String? = "", uuid: String? = "", piority: String? = "") {
        
        self.uuidService.text = "UUID:" + uuid!
        self.serviceName.text = "Unknow Service"
        self.piorityService.text = piority
    }
}
