//
//  TimestampView.swift
//  RevealableCell
//
//  Created by Shaps Mohsenin on 03/01/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class TimestampView: RevealableView {

  @IBOutlet var titleLabel: UILabel!
  
  var date: NSDate = NSDate() {
    didSet {
      titleLabel.text = dateFormatter.string(from: self.date as Date)
    }
  }
    
    var color : UIColor = .white {
        didSet {
            titleLabel.textColor = color
        }
    }
    
  
  private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }()

}
