//
//  User.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-23.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase

class User : UIModel {

    override init() {
        super.init()
    }
    
     init(snap : FIRUser) {
        super.init()
        
        //let data : NSDictionary = snap.value as! NSDictionary
        
        print(snap)
        
        /*
        if data["name"] != nil  {
            self.name =  data["name"] as! String
        }
   */
    }

    
    var firstName : String = ""
    var lastName : String = ""
    var url : String = ""
}
