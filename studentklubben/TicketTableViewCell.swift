//
//  TicketTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-22.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Spring

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var ticket: SpringView!
    var event : Event = Event() {
        didSet {
            // MARK : - Setup
            ticket.clipsToBounds = true
            ticket.layer.cornerRadius = 2
            ticket.alpha = 0.9
            
            // MARK : - Date
            let day = UILabel(frame: CGRect(x: 24, y: 20, width: 50, height: 50))
            day.font = UIFont(name: "Futura-bold", size: 32)
            day.textAlignment = .center
            day.text = "24"
            
            let month = UILabel(frame: CGRect(x: 24, y: 50, width: 50, height: 50))
            month.font = UIFont(name: "Futura", size: 16)
            month.textAlignment = .center
            month.text = "april"
            
            ticket.addSubview(day)
            ticket.addSubview(month)
            self.addSubview(dot(x: 140, y: -4))
            self.addSubview(dot(x: 140, y: Int(self.bounds.size.height) - 14))
            

        }
    }
    
    
    func dot(x : Int, y: Int) -> UIView {
        let frame = CGRect(x: x, y: y, width: 28, height: 28)
        let dot = UIView(frame: frame)
        dot.clipsToBounds = true
        dot.layer.cornerRadius = frame.size.width/2
        dot.backgroundColor = UIColor(averageColorFrom: self.event.image).darken(byPercentage: 0.4)
        
        return dot
    }

}
