//
//  MapTableViewCell.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-22.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    var event : Event = Event() {
        didSet {
            // Show on map
        }
    }
    
    var color : UIColor = .flatBlack {
        didSet {
            self.setBackgroundGradient(topColor: color, bottomColor: .clear)
        }
    }
    
    func setBackgroundGradient(topColor:UIColor, bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.0,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.mapView.frame
        let backgroundView = UIView(frame: self.mapView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.insertSubview(backgroundView, aboveSubview: self.mapView)
    }

}
