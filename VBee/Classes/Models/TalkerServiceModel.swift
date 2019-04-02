//
//  TalkerServiceModel.swift
//  UniverTalk
//
//  Created by quanarmy on 1/10/17.
//  Copyright © 2017 Paditech. All rights reserved.
//
//
//import SwiftyJSON
//import RealmSwift
import Foundation
import SwiftyJSON
class TalkerServiceModel: NSObject {
    
    dynamic var uid : String = ""
    dynamic var id : String = ""
    dynamic var displayName : String = ""
    dynamic var profileImage : String = ""
    dynamic var catchPhrase : String = ""
    dynamic var totalCalls : Int = 0
    dynamic var goodPercentage : Double = 0.0
    dynamic var descriptions : String = ""
    var stripeCustomerId = [String: Any]()
    dynamic var tags = [String: String]()
    dynamic var price : Int = 0
    dynamic var priceUnit : String = ""
    dynamic var enabled : Bool = false
    dynamic var urls = [String: String]()
    dynamic var statistics = [String: String]()
    
    convenience init(dic: Dictionary<String, AnyObject>) {
        self.init()
        
        self.uid = dic["uid"] as! String? ?? ""
        self.id = dic["id"] as! String? ?? ""
        self.displayName = dic["display_name"] as! String? ?? ""
        self.profileImage = dic["profile_image"] as! String? ?? ""
        self.catchPhrase = dic["catchphrase"] as! String? ?? ""
        self.descriptions = dic["description"] as! String? ?? ""
        self.stripeCustomerId = dic["stripe_account"] as!  [String: Any]? ?? [:]
        self.price = dic["price"] as? Int ?? 0
        self.totalCalls = dic["phone_count"] as? Int ?? 0
        self.priceUnit = dic["currency_unit"] as! String? ?? ""
        self.tags = dic["tags"] as! [String : String]? ?? [:]
        self.enabled = dic["enabled"] as? Bool ?? true
        self.urls = dic["urls"] as! [String : String]? ?? [:]
//        self.statistics = dic["statistics"] as? [String : String] ?? [:]
        
        if let statistics = dic["statistics"] {
            if let totalCalls : Int = statistics["total_call"] as! Int? {
                self.totalCalls = totalCalls
            } else {
                self.totalCalls = 0
            }
            
            if let percent: Double = statistics["good_percentage"] as! Double? {
                self.goodPercentage = percent
            } else {
                self.goodPercentage = 0.0
            }
        }
    }
    
    func getTagsString() -> String {
        
        var result = ""
        
        for key in self.tags.keys {
            
            result = result + " " + tags[key]!
        }
        
        if result.characters.count > 0 {
            
            return result.substring(from: 1)
        }
        
        return result
    }
    
    func getUrlString() -> [String] {
        
        var result: [String] = []
        
        for key in self.urls.keys {
            
            result.append(urls[key]!)
        }
        
        return result
    }

}

