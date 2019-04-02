//
//  Constants.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2016 PaditechDev1. All rights reserved.
//

import Foundation
import UIKit

// MARK: CompletionHandler
typealias CompletionHandler = (Bool, Int, AnyObject?) -> ()

// MARK: - All Constant in app
// APP URL
var kBaseURL = "http://www.vbee.com.vn:8686"
let APP_VERSION = "0.1.0"
let FIRST_INSTALL_APP = "FIRST_INSTALL_APP"

// MARK: - CHECK IPhone and OS Version

public let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
public let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
public let IS_RETINA = (UIScreen.main.scale >= 2.0)
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let SCREEN_MAX_LENGTH = fmax(SCREEN_HEIGHT, SCREEN_WIDTH)
public let SCREEN_MIN_LENGTH = fmin(SCREEN_WIDTH, SCREEN_HEIGHT)

public let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
public let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
public let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
public let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

public let WINSIZE = UIApplication.shared.keyWindow?.frame.size
public let SCREENSIZE = UIScreen.main.bounds.size

// MARK: - App name
public let APP_NAME = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

public let kRemoveAllDevice: Bool = false


// Standard UserDefault
let SETTINGs = UserDefaults.standard

class Constants {
    //MARK: - Contants will use in all class
    
    static let isTestLink = false
    
    static var kAccessToken : String {
        
        get {
            
            return UserDefaults.standard.object(forKey: "ACCESS_TOKEN") as? String ?? ""
        }
        
        set(new) {
            
            UserDefaults.standard.setValue(new, forKey: "ACCESS_TOKEN")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var kUserId: Int {
        
        get {
            
            return UserDefaults.standard.object(forKey: "USER_ID") as? Int ?? 0
        }
        
        set(new) {
            
            UserDefaults.standard.set(new, forKey: "USER_ID")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var kEmail : String {
        
        get {
            
            return UserDefaults.standard.object(forKey: "EMAIL") as? String ?? ""
        }
        
        set(new) {
            
            UserDefaults.standard.setValue(new, forKey: "EMAIL")
            UserDefaults.standard.synchronize()
        }
    }
    
    // Convinient function
    internal class func RGBA2UIColor(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    internal class func Rgb2UIColor(red: Int, green: Int, blue: Int) -> UIColor{
        
        return Constants.RGBA2UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    internal class func colorFromImage(named: String) -> UIColor {
        return UIColor(patternImage: UIImage(named:named)!)
    }
    
    internal class func radians(degrees: CGFloat)-> CGFloat{
        
        return (degrees * CGFloat(M_PI)/180)
    }
    
    internal class func degrees(radians: CGFloat)-> CGFloat{
        
        return (radians * 180/CGFloat(M_PI))
    }
    
    // define font
    static let kRegularFont = UIFont(name: "Hiragino Sans", size: 13)
    
    // Button color
    static let kButtonFavoriteColor = Constants.Rgb2UIColor(red: 234, green: 83, blue: 72)
    static let kButtonUnFavoriteColor = Constants.Rgb2UIColor(red: 67, green: 67, blue: 67)
    static let kButtonBackgroundColor = Constants.Rgb2UIColor(red: 245, green: 242, blue: 230)
    
    
    // RegisterConstant
    internal struct RegisterMode {
        let kModeRegister: Int = 0
        let kModeEdit: Int = 1
    }
    
    // Edit answer mode
    internal struct AnswerMode {
        internal let kModePost = 0
        internal let kModeEdit = 1
    }
    
    // Edit answer mode
    internal struct QuestionMode {
        internal let kModePost = 0
        internal let kModeEdit = 1
    }
    
    // Select category Mode
    internal struct SelectCategoryMode{
        internal let kModeMutiple = 0
        internal let kModeOne = 1
    }

    static let kTitleNavigationColor = UIColor.darkGray
    
    static let kBarButtonItemFont = UIFont.systemFont(ofSize: 15)
    static let kTitleControllerFont = UIFont.boldSystemFont(ofSize: 15)
    
    
    // Icon selected and un selected
    static let kImageSelected = UIImage(named: "checked")
    static let kImageUnSelected = UIImage(named: "check")
    
}

// MARK: - Public func and variable
// Local String function
func LANGTEXT(key: String)-> String{
    
    return NSLocalizedString(key, comment: "")
}

func showAlert(key: String)-> String{
    
    return NSLocalizedString(key, comment: "")
}

func + (left: UIColor, right: UIColor) -> UIColor {
    var leftRGBA = [CGFloat](repeating: 0.0, count: 4)
    var rightRGBA = [CGFloat](repeating: 0.0, count: 4)
    
    left.getRed(&leftRGBA[0], green: &leftRGBA[1], blue: &leftRGBA[2], alpha: &leftRGBA[3])
    right.getRed(&rightRGBA[0], green: &rightRGBA[1], blue: &rightRGBA[2], alpha: &rightRGBA[3])
    
    return UIColor(
        red: (leftRGBA[0] + rightRGBA[0]) / 2,
        green: (leftRGBA[1] + rightRGBA[1]) / 2,
        blue: (leftRGBA[2] + rightRGBA[2]) / 2,
        alpha: (leftRGBA[3] + rightRGBA[3]) / 2
    )
}

// MARK: - Google API key
public let kGoogleAPIKey = "AIzaSyC_KsQ119G8aWKLA-Kmhy-4t_cU8178b2Y"

// MARK: - Notification name
public let kNewDeviceNotification = "NEW_DEVICE"
public let kAddDeviceSuccess      = "ADD_SUCCED"
public let kMyDeviceEvent         = "MY_DEVICE_EVENT"
