//
//  NSDateExtension.swift
//  Visunite
//
//  Created by quanarmy on 01/24/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation

extension NSDate {
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self as Date)
    }
}
