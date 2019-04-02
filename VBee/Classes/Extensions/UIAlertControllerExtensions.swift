//
//  UIAlertControllerExtensions.swift
//  VBee
//
//  Created by datxqv on 2/26/17.
//  Copyright © 2017 VBee. All rights reserved.
//

import UIKit

//
//  UIAlertViewControllerExtensions.swift
//  DQ_User
//
//  Created by datxqv on 2/24/17.
//  Copyright © 2017 Paditech Inc. All rights reserved.
//
import UIKit

extension UIAlertController {
    
    func showDefault(title: String, message: String, complete: @escaping () -> ()) {
        
        self.message = message
        self.title = title
        
        let alertAction = UIAlertAction(title: LANGTEXT(key: "OK"), style: .cancel) { (action) in
            
            complete()
        }
        self.addAction(alertAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: {
            
        })
    }
    
    func showDefault2(title: String, message: String, complete: @escaping (Bool) -> ()) {
        
        self.message = message
        self.title = title
        
        let okAction = UIAlertAction(title: LANGTEXT(key: "OK"), style: .default) { (action) in
            
            complete(true)
        }
        
        let cancelAction = UIAlertAction(title: LANGTEXT(key: "CANCEL"), style: .cancel) { (action) in
            
            complete(false)
        }
        
        self.addAction(okAction)
        self.addAction(cancelAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: {
            
        })
    }
    
    func showDefault(title: String, message: String) {
        
        self.message = message
        self.title = title
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            
        }
        self.addAction(alertAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: true, completion: {
            
        })
    }
    
    class func customInit() -> UIAlertController {
        
        return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
}
