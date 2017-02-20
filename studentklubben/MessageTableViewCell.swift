//
//  MessageTableViewCell.swift
//  Doit
//
//  Created by Per Sonberg on 2016-10-28.
//  Copyright © 2016 Per Sonberg. All rights reserved.
//

import UIKit

class MessageTableViewCell: RevealableTableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageLabel: InsetLabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var message : Message = Message() {
        didSet {
            let screen = UIScreen.main.bounds
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = message.text
            self.messageLabel.clipsToBounds = true
            //self.dateLabel.text = "Nu"//message.created.timeAgoSinceNow()
            self.separatorInset = .zero
            self.layoutMargins = .zero
            self.messageLabel.layer.cornerRadius = 14
            self.messageLabel.preferredMaxLayoutWidth = screen.width * 0.8
            //self.messageLabel.sizeToFit()
            
            if self.userImage != nil {
                print("User image")
                self.userImage.layer.cornerRadius = 14
            }
        }
    }

}
