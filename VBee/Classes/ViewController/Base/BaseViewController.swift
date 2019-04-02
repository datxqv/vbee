//
//  BaseViewController.swift
//  VBee
//
//  Created by daicashigeru on 4/1/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let activityData = ActivityData(size: nil, message: nil, messageFont: nil, type: .ballSpinFadeLoader, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil)
func showLoading() {
    
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
        
        hideLoading()
    }
}

func hideLoading() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
}

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

