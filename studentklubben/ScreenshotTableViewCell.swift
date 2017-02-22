//
//  ScreenshotTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-19.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit

class ScreenshotTableViewCell: UITableViewCell {

    @IBOutlet weak var screenshotLabel: UILabel!
    
    func update(message : Message, color : UIColor) {
        self.screenshotLabel.textColor = color
        
        if message.user != "me" {
            self.screenshotLabel.text = message.user + " tog en skärmdump"
        }
    }

}
