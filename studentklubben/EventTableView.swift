//
//  EventTableView.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-14.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import SwiftyButton
import Firebase

extension EventViewController {
    func firebase()  {
        let ref = FIRDatabase.database().reference().child("events").child(self.event.id).child("messages").queryOrdered(byChild: "created")
        
        ref.observe(FIRDataEventType.childAdded) { (snap : FIRDataSnapshot) in
            let new = Message(snap: snap)
            if !self.event.messages.contains(where: { (message : Message) -> Bool in
                if message.id == new.id {
                    return true
                }
                return false
            }) {
                
                // MARK : - Insert
                self.event.messages.insert(new, at: 0)
                if self.currentState == .chat {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.top)
                    self.tableView.endUpdates()
                }
            }
        }
        
        ref.observe(FIRDataEventType.childChanged) { (snap : FIRDataSnapshot) in
            
        }
        
        ref.observe(FIRDataEventType.childRemoved) { (snap : FIRDataSnapshot) in
            
        }
    }
}
