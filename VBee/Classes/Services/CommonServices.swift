//
//  CommonServices.swift
//  UniverTalk
//
//  Created by quanarmy on 1/10/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import UIKit

class CommonServices: NSObject {

    class func getTwilioAccessToken(completionHandler: @escaping CompletionHandler) -> () {
        
        AlamofireClient.sharedInstance.GET(urlString: "\(Constants.kBaseURL)/api/twilio-access-token/id-client", parameters: [:]) { (status, statusCode, data) in
            if status == true {
                let json = JSON(data!)
                
                let result = json["result"].int
                if result == 1 {
                    
                    
                    completionHandler(true, statusCode, nil)
                } else {
                    completionHandler(false, result!, nil)
                }
            } else {
                completionHandler(false, statusCode, data)
            }
        }
    }
    
    class func sendFCM(completionHandler: @escaping CompletionHandler) -> () {
        
        var headers = ["Content-Type":"application/json",
                      "Authorization":"key=AAAAx86W99c:APA91bHtavwD7rmenSMsWRczVFLhxG2NDTcKG7IQEPc4MmxYGmYDQMlMnT4POU8yTe07dv_94WipU-OsQAB7CBERTdEKTgUPLt7se3HVnik8PX1rvVH6JdurDudkG1dPaMIerG7QPuh_"
                      ]
        
        let parameters: Parameters = [
            "to": "euL6wR342KA:APA91bFY1-KD3-E6AXvX_CG6rhiPjqa_gex-0yUZhtPbXx9mbWNTxzHtHUr4XANt0CO_DKb_e4sbpu9VRuVcEtsoTVMLrXgeRy2YtlP89lrQiEzTMiw_QI8cRccLiombjLUh9VClzRpG",
            "notification": [
                "body": "body"
            ]
        ]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            } else {
                
            }
        }
    }
    
    class func makeCall(parameters: [String: AnyObject],completionHandler: @escaping CompletionHandler) -> () {
        
        let parameters = parameters
        
        AlamofireClient.sharedInstance.POST(urlString: "dial", parameters: parameters as [String : AnyObject]?) { (status, statusCode, data) in
            if status == true {
                let json = JSON(data!)
                
                if json["call_id"].exists() {
                    completionHandler(true, statusCode, json["call_id"].stringValue as AnyObject?)
                } else {
                    completionHandler(false, statusCode, data)
                }
            } else {
                
            }
        }
        
    }
    
    // MARK: - Decline call
    class func declineCall(parameters: [String: AnyObject],completionHandler: @escaping CompletionHandler) -> () {
        
        let parameters = parameters
        
        AlamofireClient.sharedInstance.POST(urlString: "decline", parameters: parameters as [String : AnyObject]?) { (status, statusCode, data) in
            if status == true {
                completionHandler(true, statusCode, data)
            } else {
                completionHandler(false, statusCode, data)
            }
        }
        
    }
    
    class func charge(parameters: [String: AnyObject],completionHandler: @escaping CompletionHandler) -> () {
        
        let parameters = parameters
        
        AlamofireClient.sharedInstance.POST(urlString: "charge", parameters: parameters as [String : AnyObject]?) { (status, statusCode, data) in
            if status == true {
                
            } else {
                
            }
        }
        
    }
    
}
