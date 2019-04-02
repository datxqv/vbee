//
//  CallInfoModel.swift
//  UniverTalk
//
//  Created by quanarmy on 1/11/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation
import SwiftyJSON

class CallInfoModel: NSObject {
    dynamic var callId : String = ""
    dynamic var callerId : String = ""
    dynamic var calleeId : String = ""
    dynamic var roomId : String = ""
    dynamic var roomName : String = ""
    dynamic var singal : Int = -1
    
    convenience init(json: JSON) {
        self.init()
        callId = json["call_id"].string ?? ""
        callerId = json["caller_id"].string ?? ""
        calleeId = json["callee_id"].string ?? ""
        roomId = json["twilio_room_id"].string ?? ""
        roomName = json["room_name"].string ?? ""
        singal = json["singal"].int ?? -1
    }

}
