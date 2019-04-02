//
//  DeviceCell.swift
//  VBee
//
//  Created by daicashigeru on 3/30/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import MGSwipeTableCell
class DeviceCell: MGSwipeTableCell {

    // MARK: - Variable and IBOutlet
    @IBOutlet weak var imageViewType: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var featureButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var stateButton: VButton!
    @IBOutlet weak var batteryStateButton: VButton!
    // Access view
    
    @IBOutlet var accessEditView: UIView!
    
    var data: DeviceModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData(data: DeviceModel) {
        
        self.data = data
        self.nameLabel.text = data.name
        self.stateButton.isSelected = data.isOn
        self.typeLabel.text = data.type.uppercased()
        self.typeLabel.text = TypeModel.modelWith(id: data.categoryId).name.uppercased()
    }
    
    // MARK: - Action
    
    @IBAction func ringingButtonDidClicked(_ sender: Any) {
        
    }
    @IBAction func deleteButtonDidClicked(_ sender: UIButton) {
        
    }
    
}
