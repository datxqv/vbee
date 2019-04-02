//
//  ListServicesViewController.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import  CoreBluetooth

class ListServicesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var nibString = "ServiceCell"
    var scanController: ScanDeviceViewController?
    var arrayService: [String] = []
    var peripheralData: CBPeripheralData?
    var loadedService: [CBService: ServiceData] = [:]
    var currentChacterCtr: CharactersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initComponent()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Init
    private func initComponent() {
        
        
        // Init tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: nibString, bundle: nil), forCellReuseIdentifier: nibString)
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if let data = peripheralData, self.peripheralData?.connected == true {
            
            if data.services.count == 0 {
                
                data.peripheral?.delegate = self
                data.peripheral?.discoverServices(nil)
            }
        }
    }
}

// MARK: - PeripheralDelegate
extension ListServicesViewController : CBPeripheralDelegate {
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        
        for service in peripheral.services! {
            
            let serviceData = ServiceData()
            serviceData.service = service
            self.peripheralData?.services.append(serviceData)
        }
        
        self.tableView.reloadData()
    }
    
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        

        for characteristic in service.characteristics! {
            
            if characteristic.permissions.contains(.notify) {
                
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        if let serviceData = self.loadedService[service] {
            
            serviceData.characters = service.characteristics!
            let listCharacter = CharactersViewController(nibName:"CharactersViewController", bundle: nil)
            listCharacter.serviceData = serviceData
            listCharacter.listViewController = self
            self.currentChacterCtr = listCharacter
            self.navigationController?.pushViewController(listCharacter, animated: true)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
        print("DID WRITE")
        if error != nil {
            
            UIAlertController.customInit().showDefault(title: "Error", message: "Have some error!")
        } else {
            
            UIAlertController.customInit().showDefault(title: "Success!", message: "Wrote a string succefull")
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
            
            if let tableView = self.currentChacterCtr?.tableView {
                tableView.reloadData()
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        print("Notification")
    }
}

// MARK: UITableView delegate

extension ListServicesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.peripheralData?.services.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nibString) as! ServiceCell
        let service = self.peripheralData?.services[indexPath.row].service
        cell.fillData(name: "", uuid:service?.uuid.uuidString, piority: service?.isPrimary == true ? "Primary" : "Extend")
        
        return cell
    }
}

extension ListServicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let serviceData = self.peripheralData?.services[indexPath.row]
        
        if serviceData?.characters.count == 0 {
            self.peripheralData?.peripheral?.delegate = self
            self.peripheralData?.peripheral?.discoverCharacteristics(nil, for: (serviceData?.service)!)
            self.loadedService[(serviceData?.service)!] = serviceData
        } else {
            
            let listCharacter = CharactersViewController(nibName:"CharactersViewController", bundle: nil)
            listCharacter.serviceData = serviceData!
            listCharacter.listViewController = self
            self.currentChacterCtr = listCharacter
            self.navigationController?.pushViewController(listCharacter, animated: true)
        }
    }
}

