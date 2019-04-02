////
////  JMessage.swift
////  Visunite
////
////  Created by luckymanbk on 9/8/16.
////  Copyright © 2016 Paditech. All rights reserved.
////
//
//import UIKit
//
//public let kViewTag           = 999
//public let kMinJMessageHeight = CGFloat(30)
//public let kMaxJMessageHeight = CGFloat(64)
//
//public enum JMessageNotificationType {
//    case Message
//    case Warning
//    case Error
//    case Success
//}
//
//class JMessage: UIView {
//    
//    internal static let sharedInstance = JMessage()
//    
//    private var tapCallback :(()-> Void)?
//    
//    var titleLabel: UILabel!
//    var isShowing = false
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//    }
//    
//    convenience init() {
//        self.init(frame: CGRect.zero)
//        
//        tag = kViewTag
//        backgroundColor = UIColor.colorFromHexString(hex: "#797979")
//        
//        titleLabel = UILabel()
//        titleLabel.textColor = UIColor.white
//        titleLabel.font = FontsHelper.fontHelvetica(ofSize: 14)
//        titleLabel.numberOfLines = 0
//        titleLabel.textAlignment = .center
//        titleLabel.backgroundColor = UIColor.clear
//        self.addSubview(titleLabel)
//    }
//    
//    /**
//     show notification in a view
//     
//     - parameter viewController: current viewcontroller
//     - parameter title:          title of notification
//     - parameter delayHidden:    delay time to hide notification view, if is 0 then do not hide
//     */
//    internal func showNotificationInViewController(viewController: UIViewController, title: String, delayHidden: TimeInterval = 1.5) {
//        if viewController is UINavigationController || viewController.parent is UINavigationController {
//            let currentNavigationController = viewController as? UINavigationController ?? viewController.parent as! UINavigationController
//            if (currentNavigationController.view.viewWithTag(kViewTag) != nil) && self.isHidden == false {
//                return
//            }
//        } else {
//            if (viewController.view.viewWithTag(kViewTag) != nil) && self.isHidden == false {
//                return
//            }
//        }
//        
//        backgroundColor = UIColor.colorFromHexString("#797979")
//        self.isHidden = true
//        self.removeFromSuperview()
//        self.frame = CGRect.zero
//        
//        // setup titleLabel
//        titleLabel.text = title
//        var titleFrame = CGRect(x: 15, y: 0, width: UIScreen.width - 30, height: kMinJMessageHeight)
//        titleLabel.frame = titleFrame
//        
//        // update title frame
//        titleFrame.size.height = titleLabel.heightWithMaxWidth(UIScreen.width - 30) + 10
//        titleFrame.size.height = titleFrame.size.height > kMinJMessageHeight ? titleFrame.size.height : kMinJMessageHeight
//        titleFrame.size.height = titleFrame.size.height < kMaxJMessageHeight ? titleFrame.size.height : kMaxJMessageHeight
//        titleLabel.frame = titleFrame
//        
//        var messageFrame = CGRect.zero
//        var yPosition = CGFloat(0)
//        // add subview
//        if viewController is UINavigationController || viewController.parent is UINavigationController {
//            let currentNavigationController = viewController as? UINavigationController ?? viewController.parent as! UINavigationController
//            currentNavigationController.view.insertSubview(self, belowSubview: currentNavigationController.navigationBar)
//            if !JMessage.isNavigationBarHidden(navController: currentNavigationController) {
//                yPosition = CGFloat(64)
//            }
//            
//        } else {
//            viewController.view.addSubview(self)
//        }
//        
//        // setup frame
//        messageFrame = CGRect(x: 0, y: yPosition - titleFrame.height, width: viewController.view.frame.width, height: titleFrame.size.height)
//        self.frame = messageFrame
//        self.isHidden = false
//        
//        messageFrame.origin.y = yPosition
//        UIView.animate(withDuration: 0.2, animations: {
//            self.frame = messageFrame
//            
//        }) { (finished) in
//            if delayHidden > 0 {
//                // hide message
//                messageFrame.origin.y = yPosition - titleFrame.height
//                UIView.animate(withDuration: 0.2, delay: delayHidden, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                    self.frame = messageFrame
//                    
//                    }, completion: { (finished) in
//                        self.isHidden = true
//                        self.removeFromSuperview()
//                })
//            }
//        }
//    }
//    
//    class func isNavigationBarHidden(navController: UINavigationController) -> Bool {
//        if navController.isNavigationBarHidden {
//            return true
//        } else if navController.navigationBar.isHidden {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    
//    /**
//     show notification in a view with background color
//     
//     - parameter viewController: current viewcontroller
//     - parameter title:          title of notification
//     - parameter delayHidden:    delay time to hide notification view, if is 0 then do not hide
//     - parameter colorBackground: set background color of message
//     */
//    internal func showNotificationInViewController(viewController: UIViewController, title: String, delayHidden: TimeInterval = 1.5, backgroundColor: UIColor) {
//        if viewController is UINavigationController || viewController.parent is UINavigationController {
//            let currentNavigationController = viewController as? UINavigationController ?? viewController.parent as! UINavigationController
//            if (currentNavigationController.view.viewWithTag(kViewTag) != nil) && self.isHidden == false {
//                return
//            }
//        } else {
//            if (viewController.view.viewWithTag(kViewTag) != nil) && self.isHidden == false {
//                return
//            }
//        }
//        
//        self.backgroundColor = backgroundColor;
//        self.isHidden = true
//        self.removeFromSuperview()
//        self.frame = CGRect.zero
//        
//        // setup titleLabel
//        titleLabel.text = title
//        var titleFrame = CGRect(x: 15, y: 0, width: viewController.view.frame.width - 30, height: kMinJMessageHeight)
//        titleLabel.frame = titleFrame
//        
//        // update title frame
//        titleFrame.size.height = titleLabel.heightWithMaxWidth(viewController.view.frame.width - 30) + 10
//        titleFrame.size.height = titleFrame.size.height > kMinJMessageHeight ? titleFrame.size.height : kMinJMessageHeight
//        titleFrame.size.height = titleFrame.size.height < kMaxJMessageHeight ? titleFrame.size.height : kMaxJMessageHeight
//        titleLabel.frame = titleFrame
//        
//        var messageFrame = CGRect.zero
//        var yPosition = CGFloat(0)
//        // add subview
//        if viewController is UINavigationController || viewController.parent is UINavigationController {
//            let currentNavigationController = viewController as? UINavigationController ?? viewController.parent as! UINavigationController
//            currentNavigationController.view.insertSubview(self, belowSubview: currentNavigationController.navigationBar)
//            if !JMessage.isNavigationBarHidden(navController: currentNavigationController) {
//                yPosition = CGFloat(44)
//            }
//        } else {
//            viewController.view.addSubview(self)
//        }
//        
//        // setup frame
//        messageFrame = CGRect(x: 0, y: yPosition - titleFrame.height, width: viewController.view.frame.width, height: titleFrame.size.height)
//        self.frame = messageFrame
//        self.isHidden = false
//        
//        messageFrame.origin.y = yPosition
//        UIView.animate(withDuration: 0.2, animations: {
//            self.frame = messageFrame
//            
//        }) { (finished) in
//            if delayHidden > 0 {
//                // hide message
//                messageFrame.origin.y = yPosition - titleFrame.height
//                UIView.animate(withDuration: 0.2, delay: delayHidden, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                    self.frame = messageFrame
//                    
//                    }, completion: { (finished) in
//                        self.isHidden = true
//                        self.removeFromSuperview()
//                })
//            }
//        }
//    }
//}
