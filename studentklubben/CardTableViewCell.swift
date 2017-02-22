//
//  CardTableViewCell.swift
//  maprun
//
//  Created by Per Sonberg on 2017-01-26.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Nuke
import Haneke
import Spring
import FontAwesome_swift
import ChameleonFramework

class CardTableViewCell: UITableViewCell {

    // MARK : - Outlet
    @IBOutlet weak var titleLabel: SpringLabel!
    @IBOutlet weak var descLabel: SpringLabel!
    
    
    var backgroundImage : UIImageView?
    var color : UIColor = UIColor.flatWhite
    var event : Event = Event() {
        didSet {
            self.backgroundColor = .clear
            self.titleLabel.textColor = .flatWhite
            self.titleLabel.font = UIFont.init(name: "Futura-Bold", size: self.titleLabel.font.pointSize)
            self.descLabel.textColor = .flatWhite
            self.clipsToBounds = true
            self.layer.cornerRadius = 10
            
            titleLabel.text = event.name
            descLabel.text = event.location
            
            let screen = UIScreen.main.bounds
            var width : CGFloat = screen.size.height
            
            if screen.size.height > screen.size.width {
                width = screen.size.height
            }
            
            self.backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: self.contentView.frame.size.height))
            self.backgroundImage?.contentMode = .scaleAspectFill
            self.backgroundImage?.alpha = 0
            
            if event.url.characters.count > 0 {
       
                self.backgroundImage?.hnk_setImageFromURL(URL(string: event.url)!, placeholder: nil, format: nil, failure: { (err) in
                    if err != nil {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.backgroundColor = .flatBlack
                            self.titleLabel.animate()
                            self.descLabel.animate()
                        })
                    }
                }, success: { (image : UIImage) in
                    
                    // MARK : - Add to View
                    self.backgroundImage?.image = image
                    self.event.image = image
                    self.contentView.insertSubview(self.backgroundImage!, at: 0)
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.backgroundColor = UIColor.flatGray
                        self.backgroundImage?.alpha = 0.8
                        self.titleLabel.animate()
                        self.descLabel.animate()
                    })
                    
                })
            } else {
                self.backgroundImage?.image = event.image
            }
        }
    }
    
    func fadeOut( _ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundImage?.alpha = 0
        }) { (done : Bool) in
            completion(done)
        }
    }
    
    func fadeIn( _ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundImage?.alpha = 0
        }) { (done : Bool) in
            completion(done)
        }
    }
}
