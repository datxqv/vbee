//
//  AddDeviceViewController.swift
//  VBee
//
//  Created by daicashigeru on 3/31/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth
import RealmSwift

class AddDeviceViewController: BaseViewController {

    @IBOutlet weak var radarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var nibString = "PeripheralCell"
    let array: [CBPeripheralData] = ScanDeviceViewController.shareInstance.peripheralNew
    var currentPeriperal: CBPeripheral?
    @IBOutlet var deviceButtons: [VButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init
    private func initComponent() {
        
        // Init tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        radarView.layer.cornerRadius = radarView.frame.size.height/2.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(newDeviceNotification(notification:)), name: NSNotification.Name(rawValue: kNewDeviceNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addDeviceSuccess(notification:)), name: NSNotification.Name(rawValue: kAddDeviceSuccess), object: nil)
        
        // Init devices
        setUpDefault()
    }
    
    func initData() {
        
        updateDevice()
        self.tableView.reloadData()
    }
    
    // IBAction
    @IBAction func backButtonDidClicked(_ sender: UIButton) {
        
        if let navigationVCtr = self.navigationController {
            navigationVCtr.popViewController(animated: true)
            //navigationVCtr.popV
        }
    }
    
    @IBAction func scanButtonDidClicked(_ sender: UIButton) {
        ScanDeviceViewController.shareInstance.manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    @IBAction func deviceTaped(_ sender: UIButton) {
        
       
    }
    
    @IBAction func deviceButtonTapped(_ sender: VButton) {
        
        if Constants.kAccessToken.isEmpty == false {
            let tag = sender.tag
            
            if tag < ScanDeviceViewController.shareInstance.peripheralNew.count {
                
                let peripheralData = ScanDeviceViewController.shareInstance.peripheralNew[tag]
                // Create new device
                let params: [String: Any] = ["uuid": peripheralData.uuid!,
                                             "name": peripheralData.customName,
                                             "mac": peripheralData.macAddress!,
                                             "secretCode": peripheralData.privateID,
                                             "ownerId": Constants.kUserId ,
                                             "status": 0,
                                             "latitude": peripheralData.lat,
                                             "longitude": peripheralData.long,
                                             "extraInfo": "Hello",
                                             "config": "config",
                                             "categoryId": peripheralData.customType.id,
                                             "userToken": Constants.kAccessToken ,
                                             "releaseTime": Int(Date().timeIntervalSince1970)]
                showLoading()
                UserServices.createDevice(parameters: params, complete: { (status, statusCode, data) in
                    
                    hideLoading()
                    if status == true {
                        ScanDeviceViewController.shareInstance.peripheralNew.remove(object: peripheralData)
                        ScanDeviceViewController.shareInstance.peripheralConnected[peripheralData.peripheral!] = peripheralData
                        ScanDeviceViewController.shareInstance.manager.connect(peripheralData.peripheral!, options: nil)
                    } else {
                        
                        UIAlertController.customInit().showDefault(title: "Have a proble", message: "Please try againt")
                    }
                })
            }
        } else {
            
            print("Please relogin")
        }
    }
    
}

extension AddDeviceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ScanDeviceViewController.shareInstance.peripheralNew.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString) as! PeripheralCell
        
        cell.fillData(data: ScanDeviceViewController.shareInstance.peripheralNew[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableView Delegate
extension AddDeviceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let peripheral = ScanDeviceViewController.shareInstance.peripheralNew[indexPath.row].peripheral {
            showLoading()
            ScanDeviceViewController.shareInstance.peripheralConnected[peripheral] = ScanDeviceViewController.shareInstance.peripheralNew[indexPath.row]
            ScanDeviceViewController.shareInstance.manager.connect(peripheral, options: nil)
            self.currentPeriperal = peripheral
        }
    }
}

// MARK: - Handle notifications
extension AddDeviceViewController {
    
    func newDeviceNotification(notification: Notification) {
        
        self.tableView.reloadData()
        updateDevice()
    }
    
    func addDeviceSuccess(notification: Notification) {
        
        // Update
        hideLoading()
        updateDevice()
        self.tableView.reloadData()
        
        // Update information
        let peripheralData = notification.object as? CBPeripheralData
        let configureView = DeviceConfigure.customInit()
        configureView.peripheralData = peripheralData
        configureView.delegate = self
        TCustomAlertController.sharedInstance.setUpForController(viewController: self, subView: configureView)
        TCustomAlertController.sharedInstance.show()
    }
}

// MARK: - Show new devices func
extension AddDeviceViewController {
    
    func setUpDefault() {
        for i in 0..<self.deviceButtons.count {
            let button = self.deviceButtons[i]
            button.tag = i
            button.isHidden = true
            button.setTitle("", for: .normal)
            button.showsTouchWhenHighlighted = false
        }
    }
    
    func updateDevice() {
        
        for i in 0..<deviceButtons.count {
            deviceButtons[i].isHidden = i >= ScanDeviceViewController.shareInstance.peripheralNew.count
        }
    }
}

extension AddDeviceViewController: DeviceConfigureDelegate {
    
    func didSelectType(peripheralData: CBPeripheralData, type: TypeModel) {
        if let peripheral = peripheralData.peripheral {
             TCustomAlertController.sharedInstance.hidden()
            showLoading()
            peripheralData.customType = type
            ScanDeviceViewController.shareInstance.peripheralConnected[peripheral] = peripheralData
            
            self.currentPeriperal = peripheral
            
            //let deviceModel = DeviceModel()
            
            let realm = try! Realm()
            let model = realm.objects(DeviceModel.self).filter("ID = \(peripheralData.ID)").first
            try! realm.write() {
                
                if let deviceModel = model {
                    deviceModel.uuid = peripheralData.uuid!
                    deviceModel.name = peripheralData.customName
                    deviceModel.mac = peripheralData.macAddress!
                    deviceModel.secretCode = peripheralData.privateID
                    deviceModel.ownerId = Constants.kUserId
                    deviceModel.status = 1
                    deviceModel.latitude = Double(peripheralData.lat) ?? 0.0
                    deviceModel.longitude = Double(peripheralData.long) ?? 0.0
                    deviceModel.extraInfo = "Hello"
                    deviceModel.config = "Config"
                    deviceModel.categoryId = peripheralData.customType.id
                }
            }
            
           
            //ScanDeviceViewController.shareInstance.devices.append(deviceModel)
            ScanDeviceViewController.shareInstance.tableView.reloadData()
            
        }
        
        TCustomAlertController.sharedInstance.hidden()
    }
}

