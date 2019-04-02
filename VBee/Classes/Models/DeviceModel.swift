//
//  DeviceModel.swift
//  VBee
//
//  Created by daicashigeru on 4/2/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import Darwin
import UIKit
import RealmSwift
import SwiftyJSON

class DeviceModel: Object {

    dynamic var type = ""
    dynamic var isOn = false
    
    dynamic var ID: Int = Int(arc4random_uniform(10000))
    dynamic var uuid: String = ""
    dynamic var name: String = ""
    dynamic var mac: String = ""
    dynamic var secretCode: Int = 0
    dynamic var releaseTime: Int = 0
    dynamic var ownerId: Int = 0
    dynamic var status: Int = 0
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var config: String = ""
    dynamic var categoryId: Int = 0
    dynamic var extraInfo: String = ""
    dynamic var isDeleted = false
    
    convenience init(json: JSON) {
        
        self.init()
        ID = json["id"].intValue
        uuid = json["uuid"].stringValue
        name = json["name"].stringValue
        mac = json["mac"].stringValue
        secretCode = json["secretCode"].intValue
        releaseTime = json["releaseTime"].intValue
        ownerId = json["ownerId"].intValue
        status = json["status"].intValue
        latitude = json["latitude"].doubleValue
        longitude = json["longitude"].doubleValue
        config = json["config"].stringValue
        categoryId = json["categoryId"].intValue
        extraInfo = json["extraInfor"].stringValue
    }
}
