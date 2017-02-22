//
//  EventViewController.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-01-29.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import LatoFont
import DynamicButton
import MapKit
import Haneke
import DateTools
import SwiftyButton
import ChameleonFramework
import DGRunkeeperSwitch
import FontAwesome_swift

enum navigationState : Int {
    case info = 0
    case chat = 1
}


class EventViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK  : - Action
    func close() {
        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func didChangeNavigationState(_ sender : Any) {
        if self.currentState == .info {
            self.currentState = .chat
            
            if self.userGoing(user: "me") {
                self.searchViewOffset = 0
            }
            
        } else {
            self.currentState = .info
            self.searchViewOffset = 50
        }
        
        self.updateChatfield()
    }
    
    func didChangeEventState(_ sender : Any) {
        let switchView = sender as! DGRunkeeperSwitch

            switch switchView.selectedIndex {
            case 0:
                switchView.selectedBackgroundColor = .flatGreen
                switchView.selectedTitleColor = .flatBlack
                break
            case 1:
                switchView.selectedBackgroundColor = .flatYellow
                switchView.selectedTitleColor = .flatBlack
                break
            case 2:
                switchView.selectedBackgroundColor = .flatWhite
                switchView.selectedTitleColor = .flatBlack
                break
            default:
                break
            }
            
    }
    
    func didTouchGoing(_ sender : Any)  {
        let button : FlatButton = sender as! FlatButton
        
        // MARK : - Toggle
        if self.userGoing(user: "me") {
            self.event.going.remove(at: self.event.going.index(of: "me")!)
            self.searchViewOffset = 50.0
        } else {
            self.event.going.append("me")
            if self.currentState == .chat {
                self.searchViewOffset = 0
            }
        }
        
        if self.currentState == .chat {
            self.updateChatfield()
        }
        
        UIView.animate(withDuration: 0.3, animations: { 
            if self.userGoing(user: "me") {
                button.frame.size.width = 30
                button.color = .flatGreen
                button.highlightedColor = .flatGreenDark
                button.setTitle("", for: .normal)
                button.setImage(UIImage.fontAwesomeIcon(name: .check, textColor: .white, size: CGSize(width: 16, height: 16)), for: .normal)
            } else {
                button.frame.size.width = 30
                button.setTitle("", for: .normal)
                button.setImage(UIImage.fontAwesomeIcon(name: .check, textColor: .white, size: CGSize(width: 16, height: 16)), for: .normal)
                button.color = .flatGray
                button.highlightedColor = .flatGrayDark
            }
        }) { (done : Bool) in
            for cell in self.tableView.visibleCells {
                if cell.reuseIdentifier == "entrance" {
                    self.tableView.reloadRows(at: [self.tableView.indexPath(for: cell)!], with: UITableViewRowAnimation.automatic)
                }
            }
        }
        
        self.event.save()
        

    }

    // MARK : - Variable
    var averageColor : UIColor = .white
    var color : UIColor = .white
    let screen = UIScreen.main.bounds
    var navigationBarSnapshot: UIView!
    var navigationBarHeight: CGFloat = 0
    let kTableViewHeaderHeight : CGFloat = 500.0
    var headerView : UIView!
    var backButton : DynamicButton = DynamicButton(style: DynamicButtonStyle.caretLeft)
    var switchView : DGRunkeeperSwitch!
    var goingButton : FlatButton = FlatButton()
    var goingLabel : InsetLabel = InsetLabel()
    var timer: Timer!
    var bottomConstraint: NSLayoutConstraint?
    let inputTextField: UITextField = UITextField()
    
    var event : Event = Event() {
        didSet {
        }
    }
    
    // MARK : - Switch State
    var currentState : navigationState = .info {
        didSet {
            let lastScrollOffset = tableView.contentOffset
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                if currentState == .chat {
                    
                    // MARK : - Delete cells
                    var indexPaths : [IndexPath] = []
                    for index in 0...6 {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    // MARK : - Add cells
                    indexPaths = []
                    for index in 0...self.event.messages.count - 1 {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    
                    self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    
                } else {
                    
                    // MARK : - Delete cells
                    var indexPaths : [IndexPath] = []
                    for index in 0...self.event.messages.count - 1 {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    // MARK : - Add cells
                    indexPaths = []
                    for index in 0...6 {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    
                    self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                }
                
                self.tableView.endUpdates()
                
                tableView.layer.removeAllAnimations()
                tableView.setContentOffset(lastScrollOffset, animated: false)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.averageColor = UIColor(averageColorFrom: self.event.image).darken(byPercentage: 0.4)!
        self.color = UIColor(contrastingBlackOrWhiteColorOn: self.averageColor, isFlat: false)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.backgroundColor = averageColor
        setupHeaderView()
        self.navigationItem.title = self.event.name
        self.setTableViewBackgroundGradient(topColor: .clear, bottomColor: self.averageColor)
        
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timeStamp")
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "name")
        
         navigationItem.setRightBarButton(UIBarButtonItem(customView: UIImageView.init(image: UIImage.fontAwesomeIcon(name: .userPlus, textColor: .darkGray, size: CGSize(width: 24, height: 24)))), animated: true)
        
        self.firebase()
        
        // MARK : - Back button
        backButton = DynamicButton(style: DynamicButtonStyle.arrowLeft)
        backButton.strokeColor = .white
        backButton.frame = CGRect(x: 16, y: 32, width: 18, height: 18)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        // Switch
        switchView = navigationSwitch(color, state: self.currentState)
        switchView.frame = CGRect(x: (Int(screen.size.width)/2 - Int(switchView.bounds.size.width)/2), y: 28, width:  Int(switchView.bounds.size.width), height: Int(switchView.bounds.size.height))
        self.view.addSubview(switchView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        tableView.reloadData()
        if navigationBarSnapshot != nil {
            navigationBarSnapshot.frame.origin.y = -navigationBarHeight
            view.addSubview(navigationBarSnapshot)
        }
        
        // MARK : - Show headerView
        UIView.animate(withDuration: 0.6) {
            if let image : UIImageView = self.headerView.subviews.first as! UIImageView? {
                image.alpha = 1
            }
        }
        
        self.searchView = chatField()
        self.view.addSubview(self.searchView)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.updateHeaderView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK : - Timer
    func updateTime()  {
        if self.currentState == .info {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }
    
    
    // MARK : - Header View Image
    func setupHeaderView() {
        
        headerView = tableView.tableHeaderView
        for view in headerView.subviews {
            if view is UIImageView {
                let imageView : UIImageView = view as! UIImageView
                imageView.hnk_setImageFromURL(URL(string: event.url)!)
                let color = UIColor(averageColorFrom: imageView.image!)
                headerView.backgroundColor = color
                view.backgroundColor = color
                imageView.alpha = 0
            }
        }
    
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableViewHeaderHeight - 220, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0.0, y: -kTableViewHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableViewHeaderHeight + 220, width: tableView.bounds.size.width, height: kTableViewHeaderHeight)
        tableView.frame.origin.y = 0
        if tableView.contentOffset.y < -kTableViewHeaderHeight + 220 {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + 220
        }
        
        headerView.frame = headerRect
        tableView.sendSubview(toBack: headerView)
 
        
    }
    
    
    // MARK : - Chat
    var searchView : UIView!
    var searchViewOffset : CGFloat = 50.0 {
        didSet {
            
            // MARK : - Keyboard is closing
            if searchViewOffset == 50.0 {
                if self.inputTextField.isFirstResponder {
                    self.inputTextField.resignFirstResponder()
                }
            }
            
            // MARK : - TableView bottom inset
            if searchViewOffset == 0.0 {
                self.tableView.contentInset.bottom = 100
            } else if searchViewOffset < 0 {
                self.tableView.contentInset.bottom  = searchViewOffset * -1 + 100
            }
        }
    }
    
    
    
    
    
    // MARK : - Table View
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if self.currentState == .info {
                return 7
            } else {
                return self.event.messages.count
            }
        
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

            
            // MARK : - Confirm
            /*
            cell.textLabel?.text = ""
            self.goingButton = FlatButton(frame: CGRect(x: 12, y: 8, width: 160, height: 30))
            if self.userGoing(user: "me") {
                self.goingButton.color = .flatGreen
                self.goingButton.highlightedColor = .flatGreenDark
            } else {
                self.goingButton.color = .flatGray
                self.goingButton.highlightedColor = .flatGrayDark
            }
            self.goingButton.cornerRadius  = self.goingButton.bounds.size.height/2
            self.goingButton.frame.size.width = 30
            self.goingButton.setTitle("", for: .normal)
            self.goingButton.setImage(UIImage.fontAwesomeIcon(name: .check, textColor: .white, size: CGSize(width: 16, height: 16)), for: .normal)
            self.goingButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            self.goingButton.addTarget(self, action: #selector(EventViewController.didTouchGoing(_:)), for: .touchUpInside)
            
            if !cell.contentView.subviews.contains(where: { (view : UIView) -> Bool in
                if view is FlatButton {
                    return true
                }
                
                return false
            }) {
                cell.contentView.addSubview(self.goingButton)
            }
             */
            
           // cell.corners = [.topLeft, .topRight]
           // cell.accessoryView = navigationSwitch(.darkGray, state: currentState)
        
        
        if self.currentState == .info {
            
           
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = self.event.name
                cell.textLabel?.font = UIFont(name: "Futura-Bold", size: 26.0)
                cell.textLabel?.textColor = color
                cell.textLabel?.sizeToFit()
                //cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.layoutIfNeeded()
                return cell
            }
            if indexPath.row > 0 && indexPath.row < 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
                cell.backgroundColor = .clear
                cell.textLabel?.font = UIFont.lato(size: 16)
                cell.textLabel?.textColor = color
                cell.detailTextLabel?.textColor = .clear
                cell.selectionStyle = .none
                cell.accessoryView = nil
                cell.layer.roundCorners(.allCorners, radius: 0)
                
                // MARK : - Date
                if indexPath.row == 1 {
                    cell.imageView?.image = UIImage.init(icon: FontType.linearIcons(LinearIconType.clock), size: CGSize(width: 18, height: 18), textColor: color, backgroundColor: .clear)
                    cell.textLabel?.text = self.event.date.timeAgoSinceNow()
                }
                
                
                // MARK : - Location
                if indexPath.row == 2 {
                    cell.imageView?.image = UIImage.init(icon: FontType.linearIcons(LinearIconType.mapMarker), size: CGSize(width: 18, height: 18), textColor: color, backgroundColor: .clear)
                    cell.textLabel?.text = self.event.location
                }
                /*
                // MARK : - Guest
                if indexPath.row == 3 {
                    cell.imageView?.image = UIImage.init(icon: FontType.linearIcons(LinearIconType.heart), size: CGSize(width: 18, height: 18), textColor: color, backgroundColor: .clear)
                    cell.textLabel?.text = self.event.guest
                }
                
                // MARK : - VIP
                
                if indexPath.row == 4 {
                    cell.textLabel?.text = "VIP-Bord"
                    cell.accessoryView = UIImageView(image: UIImage.init(icon: FontType.linearIcons(LinearIconType.chevronRight), size: CGSize(width: 18, height: 18), textColor: color, backgroundColor: .clear))
                    cell.imageView?.image = UIImage.fontAwesomeIcon(name: .users, textColor: color, size: CGSize(width: 18, height: 18))
                    cell.layer.roundCorners(.allCorners, radius: 0)
                    return cell
                }
    */
                return cell
            }
            
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "visitors", for: indexPath) as! VisitorsTableViewCell
                cell.imageView?.image = UIImage.init(icon: FontType.linearIcons(LinearIconType.checkmarkCircle), size: CGSize(width: 18, height: 18), textColor: color, backgroundColor: .clear)
                cell.update()
                cell.backgroundColor = .clear
                return cell
            }
            
            
            
            if indexPath.row == 4 {
                let descCell = tableView.dequeueReusableCell(withIdentifier: "desc", for: indexPath) as! DescTableViewCell
                descCell.detailTextLabel?.numberOfLines = 0
                descCell.backgroundColor = .clear
                descCell.descLabel.textAlignment = .left
                descCell.descLabel.numberOfLines = 0
                descCell.descLabel.textColor = color
                descCell.descLabel.topInset = 0
                descCell.descLabel.font = UIFont.latoLight(size: 14)
                descCell.descLabel.text = ""//self.event.desc
                
                descCell.detailTextLabel?.sizeToFit()
                return descCell
            }
            
            
            
        } else {
            
            if self.event.messages[indexPath.row].type == .me {
                let cell = tableView.dequeueReusableCell(withIdentifier: "myMessage", for: indexPath) as! MessageTableViewCell
                configureCell(cell: cell, indexPath: indexPath, message: self.event.messages[indexPath.row])
                cell.backgroundColor = .clear
                cell.message = self.event.messages[indexPath.row]
                event.messages[indexPath.row].cell = cell
                return cell
                
            }
            
            if self.event.messages[indexPath.row].type == .screenshot {
                let cell = tableView.dequeueReusableCell(withIdentifier: "screenshot", for: indexPath) as! ScreenshotTableViewCell
                cell.update(message: event.messages[indexPath.row], color: color)
                cell.backgroundColor = .clear
                return cell
            }
            
            if self.event.messages[indexPath.row].type == .other {
                let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageTableViewCell
                configureCell(cell: cell, indexPath: indexPath, message: self.event.messages[indexPath.row])
                cell.backgroundColor = .clear
                cell.message = self.event.messages[indexPath.row]
                cell.userImage.clipsToBounds = true
                cell.userImage.layer.cornerRadius = 14
                event.messages[indexPath.row].cell = cell
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = ""
        return cell
    }
    
    // MARK : - Height
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.currentState == .info {
            if indexPath.row == 0 {
                return 32
            }
            
            if indexPath.row > 0 && indexPath.row < 3 {
                return 34
            }
            
            if indexPath.row == 3 {
                return 120
            }
        }
    
        
        if indexPath.section == 0 && self.currentState == .chat  {
            
            let message = self.event.messages[indexPath.row]
            
            if message.type != .screenshot {
                if message.cell != nil {
                    configureCell(cell: message.cell!, indexPath: indexPath, message: message)
                    return message.cell!.messageLabel.bounds.height + 24.0
                }
            }
        }
        
        return UITableViewAutomaticDimension
    }
    
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
     func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

