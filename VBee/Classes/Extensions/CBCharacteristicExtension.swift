//
//  CBCharacteristicExtension.swift
//  VBee
//
//  Created by datxqv on 3/12/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import Foundation
import CoreBluetooth

/**
 Permissions for a characteristic.
 - read:   An accessory has read permission for the characteristic.
 - write:  An accessory has write permission for the characteristic.
 - notify: An accessory can register a notification for updates to the characteristic.
 */
enum CharacteristicPermissions {
    case read, write, notify
    
    func description() -> String {
        
        switch self {
        case .read:
            
            return "Read"
        case .write:
            
            return "Write"
        case .notify:
            
            return "Notify"
        default:
            
            return "None"
        }
    }
}

/**
 This extension makes checking a characteristic's permissions cleaner and easier to read. It abstracts away the CBCharacterisProperties class and the raw value bitwise operator logic.
 */
extension CBCharacteristic {
    
    /// Returns a Set of permissions for the characteristic
    var permissions: Set<CharacteristicPermissions> {
        var permissionsSet = Set<CharacteristicPermissions>()
        
        if self.properties.rawValue & CBCharacteristicProperties.read.rawValue != 0 {
            permissionsSet.insert(CharacteristicPermissions.read)
        }
        
        if self.properties.rawValue & CBCharacteristicProperties.write.rawValue != 0 {
            permissionsSet.insert(CharacteristicPermissions.write)
        }
        
        if self.properties.rawValue & CBCharacteristicProperties.notify.rawValue != 0 {
            permissionsSet.insert(CharacteristicPermissions.notify)
        }
        
        return permissionsSet
    }
    
    func permissonDescription() -> String {
    
        var string = ""
        for item in self.permissions {
            
            string = string + " " + item.description()
        }
        
        return string
    }
    
}

extension CBPeripheral {
    
    func writeString(intValue: UInt16, for characteristic: CBCharacteristic) {
        
        print("Want write:" + intValue.description)
        if  intValue > 0 {

            var myInt: UInt16 = intValue
            let data = Data(bytes: &myInt, count: MemoryLayout.size(ofValue: myInt))
            self.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
}
