//
//  RingingDeviceViewController.swift
//  VBee
//
//  Created by daicashigeru on 4/15/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth

class RingingDeviceViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var ringingButton: VButton!
    @IBOutlet weak var deviceButton: VButton!
    
    // Current device
    var currentDevice: DeviceModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initComponent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action
    
    @IBAction func backButtonDidClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ringingButtonDidClicked(_ sender: UIButton) {
        
        if let device = self.currentDevice, device.isOn == true {
            let scanCtr = ScanDeviceViewController.shareInstance
            scanCtr.writeToMyDevice(device: device, characterUUID: "FFF1", value: "ADAD".toUnt16())//UInt16(deviceModel.secretCode))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                scanCtr.writeToMyDevice(device: device, characterUUID: "FFF2", value: 241)
            })
        }
    }
    
}

// MARK: - Init
extension RingingDeviceViewController {
    
    func initComponent() {
        
        // Add Notification
        NotificationCenter.default.addObserver(self, selector: #selector(myDeviceNotification(notification:)), name: NSNotification.Name(rawValue: kMyDeviceEvent), object: nil)
        myDeviceNotification(notification: nil)

    }
    
    func myDeviceNotification(notification: Notification?) {
        if let device = self.currentDevice {
            self.ringingButton.isEnabled = device.isOn
            deviceButton.isSelected = device.isOn
        }
    }
}
