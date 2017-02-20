//
//  DescTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-12.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit

class DescTableViewCell: UITableViewCell {

    @IBOutlet weak var descLabel: InsetLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descLabel.bottomInset = 16
        self.descLabel.topInset = 16
        self.descLabel.rightInset = 8
        self.descLabel.leftInset = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
