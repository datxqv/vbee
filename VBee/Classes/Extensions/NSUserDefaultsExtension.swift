//
//  NSUserDefaultsExtension.swift
//  LaleTore
//
//  Created by Quan Nguyen on 10/13/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setString(_ string: String, forKey: String) {
        set(string, forKey: forKey)
    }
    
    func setDate(_ date: Date, forKey: String) {
        set(date, forKey: forKey)
    }
    
    func dateForKey(_ string: String) -> Date? {
        return object(forKey: string) as? Date
    }
}
