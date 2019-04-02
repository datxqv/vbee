//
//  ArrayExtension.swift
//  Visunite
//
//  Created by quanarmy on 01/19/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation

// remove an element
extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
}

// Copy an array
protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

extension Array where Element: Copying {
    
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        
        return copiedArray
    }
}
