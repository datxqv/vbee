	//
//  ScanDeviceViewController.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth
import RealmSwift
import SwiftyJSON
import BGTableViewRowActionWithImage
import MGSwipeTableCell

class ScanDeviceViewController: BaseViewController {

    static var shareInstance: ScanDeviceViewController = ScanDeviceViewController(nibName: "ScanDeviceViewController", bundle: nil)
    // MARK: - Variable and IBOutlet
    
    @IBOutlet var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var addDeviceButton: VButton!
    @IBOutlet weak var deviceButton: UIButton!
    var nibString = "PeripheralCell"
    var deviceString = "DeviceCell"
//    var listServiceCtr :ListServicesViewController?
//    var listCharacterCtr :CharactersViewController?    // Blutooth connection
    var manager:CBCentralManager!
    var peripheral: CBPeripheral!
    var peripherals: [CBPeripheralData] = []
    var peripheralConnected: [CBPeripheral: CBPeripheralData] = [:]
    var peripheralNew: [CBPeripheralData] = []
    var myPeripherals: [DeviceModel: CBPeripheral] = [:]
    
    // Device model
    let realm = try! Realm()
    var devices = List<DeviceModel>()
    var deviceRemoving: DeviceModel?
    var deviceUpdating: DeviceModel?
    
    // MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initComponent()
        //initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        initData()
    }
    
    // MARK: - Init
    private func initComponent() {
        
        // Init tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.tableView.register(UINib(nibName: deviceString, bundle: nil), forCellReuseIdentifier: deviceString)
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0, bottom: 0.0, right: 0.0)

        
        // Init centralManager
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func initData() {
        let owerId = Constants.kUserId
        let localDevices = realm.objects(DeviceModel.self)
        
        self.devices.removeAll()
        UserServices.getListDevice(parameters: ["ownerId": owerId,
            "userToken": Constants.kAccessToken]) { (status, statusCode, data) in
            
            if status == true {
                self.devices = data as! List<DeviceModel>!
                
                for device in self.devices {
                    try! self.realm.write {
                        device.isOn = false
                        self.realm.add(device)
                        self.myPeripherals[device] = self.peripheral
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kMyDeviceEvent), object: nil)
                    }
                }
            } else {
                localDevices.forEach({ (model) in
                    if model.isDeleted == false {
                        self.devices.append(model)
                    }
                })
            }
            

            self.sychonozies()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func addButtonDidClicked(_ sender: UIButton) {
        
        let addVCtr = AddDeviceViewController(nibName: "AddDeviceViewController", bundle: nil)
        self.navigationController?.show(addVCtr, sender: true)
    }
    
    @IBAction func mapButtonDidClicked(_ sender: UIButton) {
        
        let searchCtr = SearchDeviceViewController(nibName: "SearchDeviceViewController", bundle: nil)
        self.navigationController?.show(searchCtr, sender: nil)
    }
    
    @IBAction func deviceButtonDidClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func tapInBackground(_ sender: UIButton) {
        self.searchText.resignFirstResponder()
    }
    
}

// MARK: - CentralManagerDelegate
extension ScanDeviceViewController : CBCentralManagerDelegate {
    
    // Update bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                
                // Scan device[PERIPHERAL_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false]
                central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
                print("Bluetooth is avaiable!^^")
//                _ = Timer(timeInterval: 5.0, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            } else {
                print("Bluetooth not available!><")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Device: - " + "\(advertisementData)")
        
        let peripheralData = CBPeripheralData(peripheral: peripheral, advertisementData: advertisementData as [String : AnyObject])
        peripheralData.getInfor()
        
////        if peripheralData.uuid == "F000" || peripheralData.uuid == "F001" {
//            self.peripherals.append(peripheralData)
//            self.tableView.reloadData()
////        }
        
        if peripheralData.uuid?.description == "FF00" {
            self.peripheralNew.append(peripheralData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNewDeviceNotification), object: nil)
        } else if peripheralData.uuid == "FF11" {
            self.peripheralConnected[peripheral] = peripheralData
            self.manager.connect(peripheral, options: nil)
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        if let data = self.peripheralConnected[peripheral] {
            print("Connected! Data: \(data)")
            data.connected = true
            peripheral.delegate = self
            peripheral.discoverServices(nil)
        }
        
        self.tableView.reloadData()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if let peripheralData = peripheralConnected[peripheral] {
            filterDevice(macId: peripheralData.macAddress!, isOn: false,peripheral: peripheral)
            peripheralConnected.removeValue(forKey: peripheral)
        }
    }
}

// MARK: - PeripheralDelegate
extension ScanDeviceViewController : CBPeripheralDelegate {
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("Service!")
        let peripheralData = peripheralConnected[peripheral]
        for service in peripheral.services! {
            
            let serviceData = ServiceData()
            serviceData.service = service
            peripheralData?.services.append(serviceData)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Character!")
        if (service.characteristics?.count)! > 5 {
            
            let peripheralData = self.peripheralConnected[peripheral]
            peripheralData?.characters = service.characteristics!
            for characteristic in service.characteristics! {
                
                if characteristic.permissions.contains(.notify) {
                    
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            
            // Process with new device
            if peripheralData?.uuid == "FF00" {
                print("Write")
                if let character = peripheralData?.getCharacterWithUUID(uuid: "FFF1") {
                    
                    peripheral.writeString(intValue: "F0F0".toUnt16(), for: character)
                    
                    let randomKey = "ABCD"
                    if let character6 = peripheralData?.getCharacterWithUUID(uuid: "FFF6") {
                        peripheral.writeString(intValue: randomKey.toUnt16(), for: character6)
                        //peripheralData?.privateID = randomKey.toUnt16()
                    }
                }
            } else if peripheralData?.uuid == "FF11" {
                
                
                self.filterDevice(macId: peripheralData?.macAddress ?? "", isOn: true, peripheral: peripheral)
            
                // Reset All device
                // DEBUG
                if kRemoveAllDevice {
                    if let character = peripheralData?.getCharacterWithUUID(uuid: "FFF1") {
                        
                        peripheral.writeString(intValue: "ADAD".toUnt16(), for: character)
                        
                        let randomKey = "ABCD"
                        if let character6 = peripheralData?.getCharacterWithUUID(uuid: "FFF5") {
                            peripheral.writeString(intValue: "00F1".toUnt16(), for: character6)
                            //peripheralData?.privateID = randomKey.toUnt16()
                        }
                    }
                }
            }
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
       print("Did write  \(characteristic.uuid.uuidString)")
        
        switch characteristic.uuid.uuidString {
        case "FFF1":
            
            print("Did write value for FFF1")
            break
        case "FFF2":
            
            print("Did write for FFF2")
            
            break
        case "FFF3":
            
            break
        case "FFF4":
            
            break
        case "FFF5":
            print("Did write value for FFF5")
            // Remove device here
            if let device = deviceRemoving, myPeripherals[device] == peripheral {
                
                let indexPath = IndexPath(row: devices.index(of: device)!, section: 0)
                try! self.realm.write {
//                    self.realm.delete(device)
//                    try! self.realm.commitWrite()
                    device.isDeleted = true
                }
                self.devices.remove(objectAtIndex:  devices.index(of: device)!)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                hideLoading()
            }
            
            self.manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            break
        case "FFF6":
            
            if let data = peripheralConnected[peripheral] {
                
                // New Device
                if data.uuid == "FF00" {
                    
                    // Store in device
                    try! realm.write() { // 2
                        
                        let device = DeviceModel()
                        device.type = data.customType.name
                        device.name = data.deviceName!
                        device.mac = data.macAddress!
                        device.secretCode = Int(data.privateID)
                        data.ID = device.ID
                        self.realm.add(device)
                        try! self.realm.commitWrite()
                        self.devices.append(device)
                    }
                    
                    peripheralConnected.removeValue(forKey: peripheral)
                    //peripheralNew.remove(at: peripheralNew.index(of: data)!)
                    //data.saveToLocal()
                    
                    // Post notification
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kAddDeviceSuccess), object: data)
                    self.tableView.reloadData()
                }
            }
            break
        default:
            
            break
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            
            print("Error: " + (error?.localizedDescription)!)
        } else {
            let data = characteristic.value! as NSData
            //var dataString = String(data: data!, encoding: String.Encoding.utf8)
            var value: UInt8 = 0
            data.getBytes(&value, length:  MemoryLayout<UInt8>.size)
            print("Value did updated:" + "\(value)")
            
//            if let tableView = self.currentChacterCtr?.tableView {
//                tableView.reloadData()
//            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Notification")
    }
}


// MARK: UITableView DataSource

extension ScanDeviceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: deviceString) as! DeviceCell
        let device = devices[indexPath.row]
        cell.fillData(data: device)
        
        // Config right button
        // Show riging button
        let ringingView = AccessoryView.getInstance(imageNamed: "ringing")
        ringingView.isUserInteractionEnabled = false
        let ringingButton = MGSwipeButton(title: "           ", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            
            let deviceModel = self.devices[indexPath.row]
            
            if deviceModel != nil {
                self.deviceUpdating = deviceModel
                let configureView = DeviceConfigure.customInit()
                configureView.deviceModel = deviceModel
                configureView.delegate = self
                TCustomAlertController.sharedInstance.setUpForController(viewController: self, subView: configureView)
                TCustomAlertController.sharedInstance.show()
            }

            return true
        }
        ringingView.frame = CGRect(x: 0, y: 0, width: 71, height: 94)
        ringingButton.addSubview(ringingView)
        ringingButton.backgroundColor = UIColor.clear
        
        // Delete Action
        let deleteView = AccessoryView.getInstance(imageNamed: "delete")
        deleteView.isUserInteractionEnabled = false
        let deleteButton = MGSwipeButton(title: "           ", backgroundColor: .red) {
            (sender: MGSwipeTableCell!) -> Bool in
            
            let deviceModel = self.devices[indexPath.row]
            
            if deviceModel.isOn {
                self.deviceRemoving = deviceModel
                // Write permission
                self.writeToMyDevice(device: deviceModel, characterUUID: "FFF1", value: "ADAD".toUnt16())//UInt16(deviceModel.secretCode))
                
                showLoading()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
                    // Reset device
                    self.writeToMyDevice(device: deviceModel, characterUUID: "FFF5", value: "00F1".toUnt16())
                    UserServices.deleteDevice(mac: device.mac, complete: { (status, statusCode, data) in
                        
                        if status {
                            print("Remove Success")
                            self.initData()
                        }
                    })
                })
            }
            
            return true
        }
        deleteView.frame = CGRect(x: 0, y: 0, width: 71, height: 94)
        deleteButton.addSubview(deleteView)
        deleteButton.backgroundColor = UIColor.clear
        
        // Add button to cell
        cell.rightButtons = [ringingButton, deleteButton]
        cell.rightSwipeSettings.transition = .drag
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let ringingView = AccessoryView.getInstance(imageNamed: "ringing")
//        let ringingImage = UIImage.screenCaptureWithView(ringingView, rect: ringingView.bounds)
//        let ringingAction = BGTableViewRowActionWithImage.rowAction(with: .default, title: "         ", titleColor: UIColor.darkGray, backgroundColor: UIColor.white, image: ringingImage, forCellHeight: 94, andFittedWidth: true) { (action, indexPath) in
//            
//        }
//        
//        let deleteView = AccessoryView.getInstance(imageNamed: "delete")
//        let deleteImage = UIImage.screenCaptureWithView(deleteView, rect: deleteView.bounds)
//        let deleteAction = BGTableViewRowActionWithImage.rowAction(with: .default, title: "         ", titleColor: UIColor.darkGray, backgroundColor: UIColor.white, image: deleteImage, forCellHeight: 94, andFittedWidth: false) { (action, indexPath) in
//            let deviceModel = self.devices[indexPath?.row ?? 0]
//            
//            self.deviceRemoving = deviceModel
//            // Write permission
//            self.writeToMyDevice(device: deviceModel, characterUUID: "FFF1", value: "ADAD".toUnt16())//UInt16(deviceModel.secretCode))
//            
//            showLoading()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
//                // Reset device
//                self.writeToMyDevice(device: deviceModel, characterUUID: "FFF5", value: "00F1".toUnt16())
//            })
//        }
//        
//        return [deleteAction!, ringingAction!]
//    }
    
}

// MARK: - UITableView Delegate
extension ScanDeviceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceModel = devices[indexPath.row]
        let ringingCtr = RingingDeviceViewController(nibName: "RingingDeviceViewController", bundle: nil)
        ringingCtr.currentDevice = deviceModel
        self.navigationController?.pushViewController(ringingCtr, animated: true)
    }
}

extension ScanDeviceViewController {
    
    func pauseScan() {
        
        //self.manager.stopScan()
    }
    
    func filterDevice(macId: String, isOn: Bool = true, peripheral: CBPeripheral) {
        
        for device in self.devices {
            
            if device.mac == macId {
                
                // Write permission(owner/admin)
                if isOn {
                    writeToMyDevice(device: device, characterUUID: "FFF1", value: UInt16(device.secretCode))
                }
                
                // Update state of device
                try! realm.write {
                    device.isOn = isOn
                    myPeripherals[device] = peripheral
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: kMyDeviceEvent), object: nil)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func sychonozies() {
        
        for periperalItem in self.peripheralConnected.keys {
            
            let peripheralData = self.peripheralConnected[periperalItem]
            if (peripheralData?.characters.count)! > 0 {
                
                filterDevice(macId: (peripheralData?.macAddress)!, peripheral: periperalItem)
            } else {
                filterDevice(macId: (peripheralData?.macAddress)!, isOn: false, peripheral: periperalItem)
            }
        }
    }
    
    func writeToMyDevice(device: DeviceModel, characterUUID: String, value: UInt16) {
        
        if let peripheral = myPeripherals[device] {
            
            let peripheralData = peripheralConnected[peripheral]
            if let character = peripheralData?.getCharacterWithUUID(uuid: characterUUID) {
                
                peripheral.writeString(intValue: value, for: character)
            }
        }
    }
}

// MARK: - Update device information
extension ScanDeviceViewController: DeviceConfigureDelegate {
    
    func didSelectType(peripheralData: CBPeripheralData, type: TypeModel) {
        
        TCustomAlertController.sharedInstance.hidden()
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
        
        ScanDeviceViewController.shareInstance.tableView.reloadData()
    }
}




