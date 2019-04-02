//
//  TCustomAlertController.swift
//  LaleTore
//
//  Created by PaditechDev1 on 10/4/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController

class TCustomAlertController: UIViewController {

    // Static object
    internal static let sharedInstance = TCustomAlertController()
    var currentVC: UIViewController!
    var currentSubView: UIView!
    var isHiddenStatusBar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func prefersStatusBarHidden() -> Bool {
//        return isHiddenStatusBar
//    }
    
    // Internal func
    internal func setUpForController(viewController: UIViewController, subView: UIView!) {
        
        isHiddenStatusBar = false
        self.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        currentVC = viewController
        subView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        self.view.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        self.view.addSubview(subView)
        currentSubView = subView
    }
    
    internal func show() {
        let formSheetController = MZFormSheetPresentationViewController(contentViewController: self)
        formSheetController.presentationController?.contentViewSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        formSheetController.presentationController?.shouldCenterVertically = true
        formSheetController.contentViewControllerTransitionStyle = .fade
        currentVC.present(formSheetController, animated: true, completion: nil)
    }
    
    internal func hidden() {
        self.view.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        //self.currentSubView.removeFromSuperview()
        currentVC.dismiss(animated: true) {
            // write code here
        }
    }
    
    internal func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        self.view.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        //self.currentSubView.removeFromSuperview()
        currentVC.dismiss(animated: animated) {
            completion!()
        }
    }
}
