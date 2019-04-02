//
//  RealmExtension.swift
//  Visunite
//
//  Created by luckymanbk on 8/30/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    static func execute(_ completion: (Realm) -> Void) {
        let realm = try! Realm()
        try! realm.write {
            completion(realm)
        }
    }
    
    static func deleteAll(objectType: AnyObject) {
        let realm = try! Realm()
        realm.delete(realm.objects(objectType as! Object.Type))
    }
}
