//
//  VisitorsTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-21.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import ChameleonFramework

class VisitorsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update() {
        self.scrollView.backgroundColor = .clear
        self.scrollView.isPagingEnabled = true
        self.backgroundColor = .clear
        
        // MARK : - Total Visitors
        let view = UIView(frame: CGRect(x: 0, y: 16, width: 82, height: Int(self.bounds.size.height) - 60))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.alpha = 0.6
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        label.textColor = UIColor(contrastingBlackOrWhiteColorOn: view.backgroundColor!, isFlat: true)
        label.text = "1200"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(label)
        self.scrollView.addSubview(view)

        // Add friends
        let names = ["Du", "Kalle", "Anita", "Johan", "Pontus", "Hannes", "Matilda"]
        for index in 0...names.count - 1 {
            self.scrollView.addSubview(visitorView(name: names[index], index: index))
            self.scrollView.contentSize.width = CGFloat(100 * (index + 2))
        }
    }
    
    func visitorView(name: String, index : Int) -> UIImageView {
        let image = #imageLiteral(resourceName: "43539")
        let view = UIImageView(frame: CGRect(x: ((index + 1)  * 90), y: 16, width: 82, height: Int(self.bounds.size.height) - 60))
        view.backgroundColor = UIColor(averageColorFrom: image)
        view.clipsToBounds = true
        //view.layer.cornerRadius = 10
        view.alpha = 0.6
        view.contentMode = .scaleAspectFill
        view.image = image
        
        return view
    }

}
