//
//  AlamofireClient.swift
//  JapaneseQuiz
//
//  Created by luckymanbk on 8/30/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import Alamofire
import SwiftyJSON
import ReachabilitySwift

public let kPageSize = 10

@objc class AlamofireClient: NSObject {
    
    // Instance object
    static let sharedInstance = AlamofireClient()
    var baseURL = kBaseURL
    var isShowingAlert = false
    var reachability: Reachability!
    var windowVisible = false
    
    private override init() {
        super.init()
    }
    
    func windowVisible(note: NSNotification) {
        self.windowVisible = true
    }
    
    func reachabilityChanged(note: NSNotification) {
        if let reachability = note.object as? Reachability {
            if reachability.currentReachabilityStatus == .notReachable && self.windowVisible {
//                DispatchQueue.main.asynchronously(execute: {
//                    
//                })
            }
        }
    }
    
    /**
     Check network
     
     - parameter message: message of alert view
     */
    func checkNetworksIfNeed() {
        if reachability.currentReachabilityStatus == .notReachable {
            
        }
    }

    /**
     create GET Request
     
     - parameter urlString:         the url string for request
     - parameter parameters:        parameters are involved in request
     - parameter completionHandler: a closure object
     */
    func GET(urlString: String, parameters: [String : AnyObject]?, completionHandler: @escaping CompletionHandler) -> () {
        
        let getURL: String = "\(baseURL)/\(urlString)"
        
        var aParameters = [String: AnyObject]()
        aParameters = parameters!
        
//        ZLog("URI: \(urlString) \n Params:\n \(aParameters) ")

        Alamofire.request(getURL, method: .get, parameters: aParameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler(false, 0, error as AnyObject?)
//                if error == -1001 || error.code == -1005 || error.code == -1009 {
//                    // Slow connection | connection has expired | No Connection
//                } else {
//                    completionHandler(false, 0, error as AnyObject?)
//                }
                break
                
            case .success:
                if let value = response.result.value {
//                    ZLog("GET Result: \(JSON(value))")
                    completionHandler(true, 200, value as AnyObject?)
                } else {
                    completionHandler(false, 0, response.result.error as AnyObject?)
                }
                
                break
            }
        }
    }
    
    /**
     create POST Request
     
     - parameter urlString:         the url string for request
     - parameter parameters:        parameters are involved in request
     - parameter completionHandler: a closure
     */
    func POST(urlString: String, parameters: [String : Any]?, completionHandler: @escaping CompletionHandler) -> () {
//        if reachability.currentReachabilityStatus == .notReachable {
            //            dispatchAfter(0.5, block: {
            //                TCustomAlertView.alert(Utilities.getTopViewController()!, title: Constants.LANGTEXT("MESSAGE_ERROR_INTERNET_CONNECTION"), message: nil, acceptMessage: "OK", actionBlock: nil)
            //            })
            //
            //            completionHandler(false, 404, nil)
            
//            return
//        }
        
        let getURL: String = "\(baseURL)/\(urlString)"
        
        print(getURL)
        print(parameters)
        var aParameters = [String: Any]()
        aParameters = parameters!
        
        //        ZLog("URI: \(urlString) \n Params:\n \(aParameters) ")
        
        Alamofire.request(getURL, method: .post, parameters: aParameters, encoding: URLEncoding.httpBody, headers: [
            "Content-Type": "application/x-www-form-urlencoded"
            ]).responseJSON { response in
            
            switch response.result {
            case .failure(let error):
                completionHandler(false, 0, error as AnyObject?)
                //                if error == -1001 || error.code == -1005 || error.code == -1009 {
                //                    // Slow connection | connection has expired | No Connection
                //                } else {
                //                    completionHandler(false, 0, error as AnyObject?)
                //                }
                break
                
            case .success:
                if let value = response.result.value {
                    print("Result: \(JSON(value))")
                    completionHandler(true, 200, (JSON(value) as AnyObject?))
                } else {
                    completionHandler(false, 0, response.result.error as AnyObject?)
                }
                
                break
            }
        }
    }
    
    /**
     create POST Request
     
     - parameter urlString:         the url string for request
     - parameter parameters:        parameters are involved in request
     - parameter completionHandler: a closure
     - parameter endcoding : jsonEncoding
     - parameter headers : https headers
     */
    func POSTHTTPS(apiString: String, parameters: [String : AnyObject]?, endcoding: JSONEncoding = .default, headers: HTTPHeaders = [:], completionHandler: @escaping CompletionHandler) -> () {
        //        if reachability.currentReachabilityStatus == .notReachable {
        //            dispatchAfter(0.5, block: {
        //                TCustomAlertView.alert(Utilities.getTopViewController()!, title: Constants.LANGTEXT("MESSAGE_ERROR_INTERNET_CONNECTION"), message: nil, acceptMessage: "OK", actionBlock: nil)
        //            })
        //
        //            completionHandler(false, 404, nil)
        
        //            return
        //        }
        
        let getURL: String = "\(baseURL)/\(apiString)"
        
        var aParameters = [String: AnyObject]()
        aParameters = parameters!
        
        Alamofire.request(getURL, method: .post, parameters: aParameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            if let value = response.result.value {
                print("GET Result: \(JSON(value))")
                completionHandler(true, 200, value as AnyObject?)
            } else {
                completionHandler(false, 0, response.result.error as AnyObject?)
            }
        }
    }
    
}
