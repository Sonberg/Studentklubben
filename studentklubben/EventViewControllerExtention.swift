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
        runkeeperSwitch.titleFont = UIFont.fontAwesome(ofSize: 14)
        runkeeperSwitch.titles = [String.fontAwesomeIcon(name: .calendarO), String.fontAwesomeIcon(name: .commentsO)]
        runkeeperSwitch.setSelectedIndex(state.rawValue, animated: false)
        runkeeperSwitch.backgroundColor = color.darken(byPercentage: 0.1)
        runkeeperSwitch.selectedBackgroundColor = .white
        runkeeperSwitch.titleColor = .white
        runkeeperSwitch.selectedTitleColor = color
        //runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
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
            timeStampView.width = 55
            cell.setRevealableView(timeStampView, style: message.type == .other ? .over : .slide)
        }
        
        cell.messageLabel.text = message.text
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
        
        if !isBeingDismissed {
            //navigationBarSnapshot.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: view.bounds.width, height: -scrollView.contentOffset.y)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
}
