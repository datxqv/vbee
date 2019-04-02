//
//  BluetoothModel.swift
//  VBee
//
//  Created by daicashigeru on 3/31/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit
import RealmSwift
import CoreBluetooth
class CBPeripheralData: NSObject {
    
    var ID: Int = 0
    var peripheral: CBPeripheral?
    var advertisementData: [String : AnyObject] = [:]
    var services: [ServiceData] = []
    var characters: [CBCharacteristic] = []
    var deviceName: String? = ""
    var macAddress: String? = ""
    var connectAble: Bool? = false
    var uuid: String? = ""
    var connected: Bool = false
    var customName: String = "No name"
    var customType: TypeModel = TypeModel()
    var privateID: Int = 0
    var lat: String = ""
    var long: String = ""
    
    convenience init(peripheral: CBPeripheral?, advertisementData: [String: AnyObject]) {
        
        self.init()
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.getInfor()
    }
    
    // MARK: - Get infor
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
    
    // MARK: Query charater
    
    func getCharacterWithUUID(uuid: String) -> CBCharacteristic? {
        
        for character in characters {
            
            if character.uuid.uuidString == uuid {
                
                return character
            }
        }
        
        return nil
    }
    
    // MARK: - Store Object
    func saveToLocal() {
        
        if (self.macAddress?.characters.count)! > 0 {
            
            let data = NSKeyedArchiver.archivedData(withRootObject: self)
            SETTINGs.set(data, forKey: "ble_" + self.macAddress!)
            SETTINGs.synchronize()
            
        }
    }
    
    func getAllObject() -> [CBPeripheralData] {
        
        var result: [CBPeripheralData] = []
        for key in SETTINGs.dictionaryRepresentation().keys {
            
            let stringKey = key as String
            if stringKey.contains("ble") {
                
                let data = SETTINGs.value(forKey: stringKey)
                if let peripheralData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? CBPeripheralData {
                    result.append(peripheralData)
                }
            }
        }
        
        return result
    }
}

class ServiceData {
    
    var service: CBService?
    var characters: [CBCharacteristic] = []
}
