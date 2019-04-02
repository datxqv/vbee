//
//  UserServices.swift
//  UniverTalk
//
//  Created by datxqv on 1/13/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class UserServices: NSObject {
    
    class func checkEmail(email: String, complete: @escaping CompletionHandler) {
        
        AlamofireClient.sharedInstance.POST(urlString: "user/checkEmail", parameters: ["email": email as AnyObject]) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    class func login(email: String, password: String, complete: @escaping CompletionHandler) {
        
        let userToken = Constants.kAccessToken.isEmpty ? "abcdef": Constants.kAccessToken
        let parameters: [String: Any] = ["username": email,
                                         "password": password,
                                         "userToken": userToken]
        AlamofireClient.sharedInstance.POST(urlString: "user/login", parameters: parameters) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    
                    if let token = value?["userToken"].string, token.isEmpty == false {
                        Constants.kAccessToken = token
                    }
                    Constants.kUserId = value?["userId"].intValue ?? Constants.kUserId
                    Constants.kEmail = email
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    class func resetPassword(email: String, complete: @escaping CompletionHandler) {
        
        //        let userToken = Constants.kAccessToken.isEmpty ? "abcdef": Constants.kAccessToken
        let parameters: [String: Any] = ["email": email]
        AlamofireClient.sharedInstance.POST(urlString: "app/forgotPassword", parameters: parameters) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    class func updatePassword(email: String, newPassword: String, complete: @escaping CompletionHandler) {
        
        let userToken = Constants.kAccessToken.isEmpty ? "abcdef": Constants.kAccessToken
        let parameters: [String: Any] = ["email": email,
                                         "password": newPassword,
                                         "code": userToken
                                         ]
        AlamofireClient.sharedInstance.POST(urlString: "user/updatePasswod", parameters: parameters) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    class func logout(email: String, newPassword: String, complete: @escaping CompletionHandler) {
        
        let userToken = Constants.kAccessToken.isEmpty ? "abcdef": Constants.kAccessToken
        let parameters: [String: Any] = ["email": email,
                                         "password": newPassword,
                                         "code": userToken
        ]
        AlamofireClient.sharedInstance.POST(urlString: "user/updatePasswod", parameters: parameters) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    class func register(email: String, password: String, complete: @escaping CompletionHandler) {
        
        let parameter: [String: Any?] = ["email": email,
                                         "password": password,
                                         "phonenumber":0974007537,
                                         "fullname": "datxqv",
                                         "privilege": 1,
                                         "status": 1,
                                         "latitude": 1.0,
                                         "longtitude": 1.0,
                                         "extraInfo": "Have no",
                                         "address":"Ha Noi"]
        AlamofireClient.sharedInstance.POST(urlString: "user/register", parameters: parameter ) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    
                    Constants.kAccessToken = value?["userToken"].stringValue ?? ""
                    Constants.kUserId = value?["userId"].intValue ?? 0
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    /// API Create device
    ///
    /// - Parameters:
    ///   - parameters: dictionary
    ///   - complete: Block
    class func createDevice(parameters: [String: Any], complete: @escaping CompletionHandler) {
        
        
        AlamofireClient.sharedInstance.POST(urlString: "device/addDevice", parameters: parameters) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    
    
    /// API Get list device
    ///
    /// - Parameters:
    ///   - parameters: dictionary
    ///   - complete: Return block
    class func getListDevice(parameters: [String: Any]?, complete: @escaping CompletionHandler) {
        
        AlamofireClient.sharedInstance.POST(urlString: "device/getListDevices", parameters: parameters) { (status, statusCode, data) in
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    let arrayDevice = List<DeviceModel>()
                    value?["devices"].arrayValue.forEach({ (json) in
                        let device = DeviceModel(json: json)
                        arrayDevice.append(device)
                    })
                    complete(true, 200, arrayDevice)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    /// API Delete device
    ///
    /// - Parameters:
    ///   - parameters: dictionary["mac": "", "userToken": "", "ownerId": ""]
    ///   - complete: Block
    class func deleteDevice(mac: String, complete: @escaping CompletionHandler) {
        let parameter: [String: Any] = ["userToken": Constants.kAccessToken,
                                        "ownerId": Constants.kUserId,
                                        "mac": mac]
        
        AlamofireClient.sharedInstance.POST(urlString: "device/removeDevice", parameters: parameter) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
    
    /// API Update device
    ///
    /// - Parameters:
    ///   - parameters: dictionary["mac": "", "userToken": "", "ownerId": ""]
    ///   - complete: Block
    class func updateDevice(mac: String, name: String, categoryID: Int, lat: Float, lng: Float, complete: @escaping CompletionHandler) {
        let parameter: [String: Any] = ["userToken": Constants.kAccessToken,
                                        "ownerId": Constants.kUserId,
                                        "mac": mac,
                                        "name": name,
                                        "categoryId": categoryID
                                        ,
                                        "latitude": lat,
                                        "longitude": lng
                                        ]
        
        AlamofireClient.sharedInstance.POST(urlString: "device/updateDeviceInfo", parameters: parameter) { (status, statusCode, data) in
            
            if status {
                let value: JSON? = data as? JSON
                if value?["code"].int == 1 {
                    complete(true, 200, value as AnyObject?)
                } else {
                    complete(false, 404, data)
                }
            } else {
                complete(false, 404, nil)
            }
        }
    }
}
