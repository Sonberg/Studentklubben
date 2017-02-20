//
//  RoundedTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-06.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit

class RoundedTableViewCell: UITableViewCell {

    var corners: UIRectCorner = []
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.roundCorners(self.corners, radius: self.bounds.size.height/2)
    }
}
