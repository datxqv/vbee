//
//  ScanDeviceViewController.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import CoreBluetooth

class CBPeripheralData {
    
    var peripheral: CBPeripheral?
    var advertisementData: [String : AnyObject] = [:]
    var services: [ServiceData] = []
    var deviceName: String? = ""
    var macAddress: String? = ""
    var connectAble: Bool? = false
    var uuid: String? = ""
    var connected: Bool = false
    
    convenience init(peripheral: CBPeripheral?, advertisementData: [String: AnyObject]) {
        
        self.init()
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.getInfor()
    }
    
    func getInfor() {
            
            deviceName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            

            if let uuid = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
                self.uuid = uuid[0].uuidString
                
                if uuid.count > 3 {
                    
                    macAddress = uuid[1].uuidString.divString() + ":" + uuid[2].uuidString.divString() + ":" + uuid[3].uuidString.divString()
                }
            }
            
        
            if let connectAble = advertisementData[CBAdvertisementDataIsConnectable] {
                
                if connectAble as! Bool == true {
                    
                    self.connectAble = true
                }
            }
    }
}

class ServiceData {
    
    var service: CBService?
    var characters: [CBCharacteristic] = []
}

class ScanDeviceViewController: UIViewController {

    // MARK: - Variable and IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    var nibString = "PeripheralCell"
    var listServiceCtr :ListServicesViewController?
    var listCharacterCtr :CharactersViewController?    // Blutooth connection
    var manager:CBCentralManager!
    var peripheral: CBPeripheral!
    var peripherals: [CBPeripheralData] = []
    var peripheralConnected: [CBPeripheral: CBPeripheralData] = [:]
    
    // MARK: - Default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        
        listServiceCtr = ListServicesViewController(nibName: "ListServicesViewController", bundle: nil)
        listCharacterCtr = CharactersViewController(nibName:"CharactersViewController", bundle: nil)
        initComponent()
        initData()
    }
    
    // MARK: - Init
    private func initComponent() {
        
        // Init tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.listServiceCtr?.scanController = self

        // Init centralManager
        manager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    private func initData() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: - CentralManagerDelegate
extension ScanDeviceViewController : CBCentralManagerDelegate {
    
    // Update bluetooth state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn {
                
                // Scan device[PERIPHERAL_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey:false]
                central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
                print("Bluetooth is avaiable!^^")
                _ = Timer(timeInterval: 5.0, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
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
        
//        if peripheralData.uuid == "F000" || peripheralData.uuid == "F001" {
            self.peripherals.append(peripheralData)
            self.tableView.reloadData()
//        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        if let data = self.peripheralConnected[peripheral] {
            
            data.connected = true
            let list = ListServicesViewController(nibName: "ListServicesViewController", bundle: nil)
            list.scanController = self
            list.peripheralData = data
            
            self.navigationController?.pushViewController(list, animated: true)
        }
        
        self.tableView.reloadData()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
}


// MARK: UITableView delegate

extension ScanDeviceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString) as! PeripheralCell
        let peripheralData = peripherals[indexPath.row]
        cell.fillData(data: peripheralData)
        
        return cell
    }
}

extension ScanDeviceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentData = self.peripherals[indexPath.row]
        currentData.getInfor()
        
        if currentData.connectAble! && currentData.connected == false {
            
            self.peripheralConnected[currentData.peripheral!] = currentData
            let peripheralTemp = currentData.peripheral
            
            manager.connect(peripheralTemp!, options: nil)
        }
        
        if currentData.connected == true {
            
            let list = ListServicesViewController(nibName: "ListServicesViewController", bundle: nil)
            list.scanController = self
            list.peripheralData = currentData
            
            self.navigationController?.pushViewController(list, animated: true)
        }
    }
}

extension ScanDeviceViewController {
    
    func pauseScan() {
        
        //self.manager.stopScan()
    }
}


