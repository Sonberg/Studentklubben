//
//  CardTableViewCell.swift
//  maprun
//
//  Created by Per Sonberg on 2017-01-26.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesome_swift
import ChameleonFramework

class CardTableViewCell: UITableViewCell {

    // MARK : - Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    var backgroundImage : UIImageView?
    var color : UIColor = UIColor.flatWhite
    var event : Event = Event() {
        didSet {
            self.backgroundColor = .flatBlack
            self.titleLabel.textColor = .flatWhite
            self.descLabel.textColor = .flatWhite
            self.clipsToBounds = true
            self.layer.cornerRadius = 6
            
            titleLabel.text = event.name
            descLabel.text = event.location
            
            let screen = UIScreen.main.bounds
            var width : CGFloat = screen.size.height
            
            if screen.size.height > screen.size.width {
                width = screen.size.height
            }
            
            self.backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: self.contentView.frame.size.height))
            
            if event.url.characters.count > 0 {
                let resource = ImageResource(downloadURL: URL(string: event.url)!, cacheKey: event.id)
                self.backgroundImage?.kf.indicatorType = .activity
                self.backgroundImage?.kf.setImage(with: resource)
            } else {
                self.backgroundImage?.image = event.image
            }
            
            self.backgroundImage?.contentMode = .scaleAspectFill
            self.backgroundImage?.alpha = 0.7
            self.contentView.insertSubview(backgroundImage!, at: 0)
            
            let border = UIView(frame: CGRect(x: 0, y: self.contentView.frame.size.height - 8, width: width, height: 8))
            border.backgroundColor = color
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
