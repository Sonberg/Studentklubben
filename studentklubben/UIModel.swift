//
//  UIModel.swift
//  maprun
//
//  Created by Per Sonberg on 2017-01-28.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class UIModel {
    
    init() {}
    
    init(snap : FIRDataSnapshot) {
        self.id = snap.key
    }
    
    
    // MARK : - Properties
    var id : String = ""
    var created : String = ""
    var updated : String = ""
    
    
    // MARK : - Methods
    func getImage(_ url : String, completion: @escaping (UIImage) -> Void)  {
        if url != "" {
            FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10*1024*1024, completion: { (data, error) in
                if (data != nil) {
                    completion(UIImage(data: data!)!)
                }
            })
        }
    }
    
    func randomString(_ length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    func save(ref : FIRDatabaseReference, data : [String : Any]) {
        var model : [String : Any] = data
        
        // MARk : - Save the date
        if self.id.characters.count == 0 {
            self.created = String(describing: Date())
        }
        
        self.updated = String(describing: Date())
        
        model.updateValue(self.created, forKey: "created")
        model.updateValue(self.updated, forKey: "updated")
        
        // MARK : - Update & Save
        if self.id.characters.count > 0 {
            ref.updateChildValues(model)
        } else {
            ref.setValue(model)
        }
    }
    
    func delete() {
    
    }
}
