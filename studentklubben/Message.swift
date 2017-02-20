//
//  Message.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-07.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase

enum messageType : String {
    case me = "myMessage"
    case other = "message"
    case screenshot = "screenshot"
}

class Message: UIModel {
    
    override init() {
        super.init()
    }
    
    init(type : messageType, text : String) {
        super.init()
        
        self.type = type
        self.text = text
    }
    
    override init(snap: FIRDataSnapshot) {
        super.init(snap: snap)
        let data : NSDictionary = snap.value as! NSDictionary
        
        if data["type"] != nil  {
            self.type =  messageType(rawValue: data["type"] as! String)!
        }
        
        if data["user"] != nil  {
            self.user = data["user"] as! String
        }

        
        if data["text"] != nil  {
            self.text =  data["text"] as! String
        }
        
        if data["reported"] != nil  {
            self.reported = data["reported"] as! [String]
        }

    }
    
    var type : messageType = .other
    var user : String = ""
    var text : String = ""
    var cell : MessageTableViewCell?
    var reported : [String] = []
    
    func save(eventId: String) {
        var ref = FIRDatabase.database().reference().child("events").child(eventId).child("messages")
        if self.id.characters.count > 0 {
            ref = ref.child(self.id)
        } else {
            ref = ref.childByAutoId()
        }
        
        let data : [String : Any] = ["type" : self.type.rawValue, "user" : self.user, "text" : self.text, "reported" : self.reported]
        
        super.save(ref: ref, data: data)
    }
}
