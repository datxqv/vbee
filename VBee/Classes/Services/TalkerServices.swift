//
//  TalkerServices.swift
//  UniverTalk
//
//  Created by datxqv on 1/13/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseInstanceID
import FirebaseDatabase
import FirebaseStorage

class TalkerServices: NSObject {

    class func getTalker(talkerId: String, completionHandler: @escaping CompletionHandler) -> () {
        
        let ref = FIRDatabase.database().reference()
        ref.child("talker_services").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            if snapshot.hasChild(talkerId) {
                let value = snapshot.childSnapshot(forPath: talkerId).valueInExportFormat() as! NSDictionary
                
                let talker = TalkerServiceModel(dic: value as! Dictionary<String, AnyObject>)
                completionHandler(true, 200, talker)
            } else {
                completionHandler(false, 400, nil)

            }
            
            
        }) { (error) in
             completionHandler(false, 404, nil)
        }
       
    }
    
    class func saveTalker(postData: TalkerPostModel) {
        
        if let user = FIRAuth.auth()?.currentUser {
            
            print("TALKER: \(user.uid)")
            let ref = FIRDatabase.database().reference()
            let talkerRef = ref.child("talker_services").child(user.uid)

            talkerRef.child("id").setValue(postData.id?.text)
            talkerRef.child("display_name").setValue(postData.displayName.text)
            talkerRef.child("profile_image").setValue("https://google.com")
            talkerRef.child("catchphrase").setValue(postData.catchPhrase?.text)
            talkerRef.child("description").setValue(postData.comments.text)
            
            if postData.striples["account_id"] != nil {
                
                let stripeDict: [String: Any] = postData.striples
                talkerRef.child("stripe_account").setValue(stripeDict)
            }
            talkerRef.child("price").setValue(Int(postData.priceSetting.text.characters.count > 0 ? postData.priceSetting.text : "0"))
            talkerRef.child("currency_unit").setValue("vnd")
            
            if postData.notes.boolValue {
                talkerRef.child("enabled").setValue(postData.notes.intValue > 0)
            } else {
                talkerRef.child("enabled").setValue(true)
            }
            
            if postData.tags.count > 0 {
                talkerRef.child("tags").setValue("")
                postData.tags.forEach({ (tag) in
                    
                    let key =  talkerRef.child("tags").childByAutoId().key
                    let talkReftChild = talkerRef.child("tags").child(key)
                    talkReftChild.setValue("#" + tag.replacingOccurrences(of: "#", with: ""))
                })
            }
            
            if postData.hasUrl() {
                talkerRef.child("urls").setValue("")
                postData.urlText.forEach({ (textField) in
                    
                    if (textField.text?.characters.count)! > 0 {
                        let key =  talkerRef.child("urls").childByAutoId().key
                        let talkReftChild = talkerRef.child("urls").child(key)
                        talkReftChild.setValue(textField.text)
                    }
                })
            }
            
            if postData.imageAvatar?.image != nil && postData.selectedImage.boolValue {
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://univertalk-156004.appspot.com")
                // Data in memory
                let data = UIImageJPEGRepresentation((postData.imageAvatar?.image!)!, 0.5)
                
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("photos")
                
                
                if let user = FIRAuth.auth()?.currentUser {
                    
                    let imageRef = riversRef.child(user.uid)
                    // Upload the file to the path "images/rivers.jpg"
                    let metaData = FIRStorageMetadata()
                    metaData.contentType = "image/jpg"
                    let uploadTask = imageRef.put(data!, metadata: metaData) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            
                            print("Error")
                            return
                        }
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        let downloadURL = metadata.downloadURL()?.absoluteString
                        talkerRef.child("profile_image").setValue(downloadURL)
                    }
                }
                
                
            }
        }
    }

}
