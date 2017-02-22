//
//  EventViewControllerExtention.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-01-30.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Foundation
import FontAwesome_swift
import DGRunkeeperSwitch
import SPXRevealableView

// MARK : - Header View
extension EventViewController {
    
    // MARK : - User Going
    func userGoing(user : String) -> Bool {
        return self.event.going.contains(user)
    }
    
    // MARK : - Navigation Switch
    func navigationSwitch(_ color : UIColor, state : navigationState) -> DGRunkeeperSwitch {
        let runkeeperSwitch = DGRunkeeperSwitch(titles: ["Info","Chat"])
        runkeeperSwitch.titleFont = UIFont.fontAwesome(ofSize: 15)
        runkeeperSwitch.titles = [String.fontAwesomeIcon(name: .calendar), String.fontAwesomeIcon(name: .comments)]
        runkeeperSwitch.setSelectedIndex(state.rawValue, animated: false)
        runkeeperSwitch.backgroundColor = color.withAlphaComponent(0.4)
        runkeeperSwitch.selectedBackgroundColor = color
        runkeeperSwitch.titleColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true).withAlphaComponent(0.8)
        runkeeperSwitch.selectedTitleColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 120.0, height: 30.0)
        runkeeperSwitch.sizeToFit()
        runkeeperSwitch.addTarget(self, action: #selector(EventViewController.didChangeNavigationState(_:)), for: .valueChanged)
        return runkeeperSwitch
    }
    
    func updateChatfield()  {
        UIView.animate(withDuration: 0.3, animations: {
            if self.searchView != nil {
                self.searchView.frame.origin.y = self.screen.size.height - 50.0 + self.searchViewOffset
            }
        })
    }
}

extension EventViewController {
    
    func configureCell(cell: MessageTableViewCell, indexPath: IndexPath, message: Message) {
        
        if let timeStampView = tableView.dequeueReusableRevealableViewWithIdentifier("timeStamp") as? TimestampView {
            timeStampView.date = NSDate.init()
            timeStampView.color = color
            timeStampView.width = 55
            cell.setRevealableView(timeStampView, style: message.type == .other ? .over : .slide)
        }
        
        cell.messageLabel.text = message.text
    }
    
    func setTableViewBackgroundGradient(topColor:UIColor, bottomColor:UIColor) {
        
        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations = [0.1,1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.headerView.frame
        let backgroundView = UIView(frame: self.headerView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        self.tableView.insertSubview(backgroundView, aboveSubview: self.headerView)
    }
}


// MARK: ExpandingTransitionPresentedViewController
extension EventViewController: ExpandingTransitionPresentedViewController {
    
    func expandingTransition(_ transition: ExpandingCellTransition, navigationBarSnapshot: UIView) {
        self.navigationBarSnapshot = navigationBarSnapshot
        self.navigationBarHeight = navigationBarSnapshot.frame.height
    }
}

// MARK: UIScrollViewDelegate

extension EventViewController
{
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        if self.searchView != nil {
            self.searchView.frame.origin.y = self.screen.size.height - 50.0 + self.searchViewOffset
        }
        
        if self.switchView != nil {
            if self.tableView.contentOffset.y > -16 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backButton.alpha = 0
                    self.switchView.alpha = 0
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backButton.alpha = 1
                    self.switchView.alpha = 1
                    
                })
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
}
