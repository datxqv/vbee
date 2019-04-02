//
//  StringExtension.swift
//  testFireBase
//
//  Created by datxqv on 1/5/17.
//  Copyright © 2017 datxqv. All rights reserved.
//

import UIKit

extension String {

    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        do {
            //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,12}"
            let stricterFilterString = "^.{8,12}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
            return passwordTest.evaluate(with: self)
        } catch {
            return false
        }
    }
    
    func isValidPhoneNumber() -> Bool {
        let types:NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, characters.count)).first?.phoneNumber {
            return match == self
        }else{
            return false
        }
    }
	
	//Handle cut string
	func index(from: Int) -> Index {
		return self.index(startIndex, offsetBy: from)
	}
	
	func substring(from: Int) -> String {
		let fromIndex = index(from: from)
		return substring(from: fromIndex)
	}
	
	func substring(to: Int) -> String {
		let toIndex = index(from: to)
		return substring(to: toIndex)
	}
	
	func substring(with r: Range<Int>) -> String {
		let startIndex = index(from: r.lowerBound)
		let endIndex = index(from: r.upperBound)
		return substring(with: startIndex..<endIndex)
	}

     func divString() -> String {
        
        if self.characters.count == 4 {
            
            let str: NSMutableString = NSMutableString()
            str.append(self)
            str.insert(":", at: 2)
            
            return str as String
        }
        return ""
    }
    
    func toUnt16() -> UInt16 {
        
        return UInt16(self, radix: 16)!
    }
}
