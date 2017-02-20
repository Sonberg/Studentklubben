//
//  EventChatExtension.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-18.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Foundation

extension EventViewController {
    
  
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options:   NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
