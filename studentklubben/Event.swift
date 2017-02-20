//
//  Event.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-01-30.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase
import DateTools
import Kingfisher

class Event: UIModel {
    override init() {
        super.init()
    }
    
    init(image : UIImage, name: String, date: String, location : String) {
        super.init()
        
        self.image = image
        self.name = name
        self.location = location
    }
    
    override init(snap : FIRDataSnapshot) {
        super.init(snap: snap)
        
        let data : NSDictionary = snap.value as! NSDictionary
        
        if data["name"] != nil  {
            self.name =  data["name"] as! String
        }
        
        if data["desc"] != nil  {
            self.desc = data["desc"] as! String
        }
        
        if data["date"] != nil  {
            //self.date =  data["date"] as! String
        }
        
        if data["guest"] != nil  {
            self.guest =  data["guest"] as! String
        }
        
        if data["location"] != nil  {
            self.location =  data["location"] as! String
        }
        
        if data["going"] != nil  {
            self.going = data["going"] as! [String]
        }
        
        if data["url"] != nil  {
            self.url = data["url"] as! String
            
            ImageDownloader.default.downloadImage(with: URL(string: self.url)!, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
                if image != nil {
                    self.image = image!
                }
            })
        }
        
    }
    
    var url : String = "";
    var image : UIImage = #imageLiteral(resourceName: "4465127-party-wallpapers")
    var name : String = ""
    var desc : String = ""
    var date : NSDate = NSDate()
    var guest : String = "Panetoz"
    var location : String = ""
    var going : [String] = []
    var messages : [Message] = []
    
    
    
    func save() {
        var ref = FIRDatabase.database().reference().child("events")
        if self.id.characters.count > 0 {
            ref = ref.child(self.id)
        } else {
            ref = ref.childByAutoId()
        }
        
        let data : [String : Any] = ["going" : self.going]
        
        super.save(ref: ref, data: data)
    }
}
