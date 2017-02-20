//
//  EventViewController.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-01-29.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import DynamicButton
import MapKit
import SwiftyButton
import LatoFont
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
    let screen = UIScreen.main.bounds
    var navigationBarSnapshot: UIView!
    var navigationBarHeight: CGFloat = 0
    let kTableViewHeaderHeight : CGFloat = 300.0
    var headerView : UIView!
    var backButton : DynamicButton = DynamicButton(style: DynamicButtonStyle.caretLeft)
    var goingButton : FlatButton = FlatButton()
    var goingLabel : InsetLabel = InsetLabel()
    var timer: Timer!
    
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
                        indexPaths.append(IndexPath(row: index, section: 1))
                    }
                    self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    // MARK : - Add cells
                    indexPaths = []
                    for index in 0...self.event.messages.count - 1 {
                        indexPaths.append(IndexPath(row: index, section: 1))
                    }
                    
                    self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    
                } else {
                    
                    // MARK : - Delete cells
                    var indexPaths : [IndexPath] = []
                    for index in 0...self.event.messages.count - 1 {
                        indexPaths.append(IndexPath(row: index, section: 1))
                    }
                    self.tableView.deleteRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                    
                    // MARK : - Add cells
                    indexPaths = []
                    for index in 0...6 {
                        indexPaths.append(IndexPath(row: index, section: 1))
                    }
                    
                    self.tableView.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
                }
                
                self.tableView.endUpdates()
                
                tableView.layer.removeAllAnimations()
                tableView.setContentOffset(lastScrollOffset, animated: false)

            }
           // self.updateHeaderView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        setupHeaderView()
        self.tableView.backgroundColor = .white
        self.navigationItem.title = self.event.name
        
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "timeStamp")
        tableView.registerNib(UINib(nibName: "TimestampView", bundle: nil), forRevealableViewReuseIdentifier: "name")
        
         navigationItem.setRightBarButton(UIBarButtonItem(customView: UIImageView.init(image: UIImage.fontAwesomeIcon(name: .userPlus, textColor: .darkGray, size: CGSize(width: 24, height: 24)))), animated: true)
        
        self.firebase()
        
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
    
    // MARK : - Timer
    func updateTime()  {
        if self.currentState == .info {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: UITableViewRowAnimation.automatic)
        }
    }
    
    
    // MARK : - Header View Image
    func setupHeaderView() {
        
        headerView = tableView.tableHeaderView
        for view in headerView.subviews {
            if view is UIImageView {
                let imageView : UIImageView = view as! UIImageView
                imageView.image = self.event.image
                let color = UIColor(averageColorFrom: imageView.image!)
                headerView.backgroundColor = color
                view.backgroundColor = color
                imageView.alpha = 0
            }
        }
    
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        self.tableView.contentInset = UIEdgeInsets(top: kTableViewHeaderHeight - 44, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0.0, y: -kTableViewHeaderHeight)
        updateHeaderView()
    }
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableViewHeaderHeight + 44, width: tableView.bounds.size.width, height: kTableViewHeaderHeight)
        tableView.frame.origin.y = 0
        if tableView.contentOffset.y < -kTableViewHeaderHeight + 44 {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + 44
        }
        
        headerView.frame = headerRect
        tableView.sendSubview(toBack: headerView)
 
        
    }
    
    // MARK : - Screenshot
    func detectScreenshot()  {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue,
                                               using: { notification in
                                                let message = Message()
                                                message.type = .screenshot
                                                message.user = "me"
                                                message.save(eventId: self.event.id)
                                                
        })
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
                self.tableView.contentInset.bottom = 50
            } else if searchViewOffset < 0 {
                self.tableView.contentInset.bottom  = searchViewOffset * -1 + 50
            }
        }
    }
    var bottomConstraint: NSLayoutConstraint?
    let inputTextField: UITextField = UITextField()
    
    // MARK : - Chat field
    
    
    func chatField() -> UIView {
        self.inputTextField.delegate = self
        self.inputTextField.setLeftPaddingPoints(6)
        self.inputTextField.textColor = .white
        self.inputTextField.attributedPlaceholder = NSAttributedString(string: "Skriv ett medelande...",
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.inputTextField.font = UIFont.systemFont(ofSize: 14)

        setNeedsStatusBarAppearanceUpdate()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
 
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let sendButton = self.sendButton()
        sendButton.addTarget(self, action: #selector(sendMessage), for: UIControlEvents.touchUpInside)

        
        let messageInputContainerView: UIView = UIView(frame: CGRect(x: 6, y: self.screen.height, width: UIScreen.main.bounds.width - 12, height: 44))
        messageInputContainerView.backgroundColor = UIColor.darkGray
        messageInputContainerView.layer.cornerRadius = 22
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        detectScreenshot()
        messageInputContainerView.alpha = 1
        return messageInputContainerView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.searchViewOffset = -keyboardSize.height
            self.updateChatfield()
        }
    
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.searchViewOffset = 0.0
        self.updateChatfield()
    }

    
    func sendButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        button.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.paperPlane, textColor: .white, size: CGSize(width: 22, height: 22)), for: .normal)
        button.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.paperPlaneO, textColor: .white, size: CGSize(width: 24, height: 24)), for: UIControlState.highlighted)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }
    
    // MARK : - Keyboard
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func sendMessage() -> Void {
        if (self.inputTextField.text?.characters.count)! > 0 {
            let message = Message()
            message.user = "me"
            message.text = self.inputTextField.text!
            message.type = .me
            message.save(eventId: self.event.id)
            self.inputTextField.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage()
        return true
    }
    
    
    // MARK : - Table View
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            if self.currentState == .info {
                
                return 7
            } else {
                return self.event.messages.count
            }
        }
        
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // MARK : - Switch navigation cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rounded", for: indexPath) as! RoundedTableViewCell
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            
            // MARK : - Confirm
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
            
            cell.corners = [.topLeft, .topRight]
            cell.accessoryView = navigationSwitch(.darkGray, state: currentState)
            
            return cell
        }
        
        if self.currentState == .info {
            
            if indexPath.section == 1 && indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "entrance", for: indexPath)
                cell.backgroundColor = UIColor.white
                if self.userGoing(user: "me") {
                    cell.imageView?.image = UIImage.fontAwesomeIcon(name: .check, textColor: .flatGreen, size: CGSize(width: 22, height: 22))
                } else {
                    cell.imageView?.image = UIImage.fontAwesomeIcon(name: .circle, textColor: .lightGray, size: CGSize(width: 16, height: 16))
                }
                return cell
            }
            
            // MARK : - VIP
            if indexPath.section == 1 && indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
                cell.backgroundColor = .white
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.textLabel?.textColor = .darkGray
                cell.textLabel?.text = "VIP-Bord"
                cell.detailTextLabel?.textColor = .clear
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
                cell.accessoryView = UIImageView(image: UIImage.fontAwesomeIcon(name: .chevronRight, textColor: .darkGray, size: CGSize(width: 18, height: 18)))
                cell.layer.roundCorners(.allCorners, radius: 0)
                return cell
            }
            
            // MARK : - Description
            if indexPath.section == 1 && indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
                cell.backgroundColor = .white
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.textLabel?.textColor = .darkGray
                cell.textLabel?.text = "Beskrivning"
                cell.detailTextLabel?.textColor = .clear
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
                cell.accessoryView = nil
                cell.layer.roundCorners(.allCorners, radius: 0)
                return cell
            }
            
            if indexPath.section == 1 && indexPath.row == 6 {
                let descCell = tableView.dequeueReusableCell(withIdentifier: "desc", for: indexPath) as! DescTableViewCell
                descCell.detailTextLabel?.numberOfLines = 0
                descCell.descLabel.textAlignment = .left
                descCell.descLabel.numberOfLines = 0
                descCell.descLabel.textColor = .darkGray
                descCell.descLabel.topInset = 0
                descCell.descLabel.font = UIFont.systemFont(ofSize: 14)
                descCell.descLabel.text = "You asked, Font Awesome delivers with 41 shiny new icons in version 4.7. Want to request new icons? Here's how. Need vectors or want to use on the desktop? Check the cheatsheet."
                
                descCell.detailTextLabel?.sizeToFit()
                return descCell
            }
            
            
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath)
                cell.backgroundColor = .white
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                cell.textLabel?.textColor = .darkGray
                cell.detailTextLabel?.textColor = .darkGray
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14.0)
                cell.selectionStyle = .none
                cell.accessoryView = nil
                cell.layer.roundCorners(.allCorners, radius: 0)
                
                
                // MARK : - Date
                if indexPath.row == 1 {
                    //cell.imageView?.image = UIImage.fontAwesomeIcon(name: .clockO, textColor: .darkGray, size: CGSize(width: 24, height: 24))
                    cell.textLabel?.text = "Tid"
                    cell.detailTextLabel?.text = self.event.date.timeAgoSinceNow()
                }
                
                // MARK : - Location
                if indexPath.row == 2 {
                    //cell.imageView?.image = UIImage.fontAwesomeIcon(name: .mapPin, textColor: .darkGray, size: CGSize(width: 24, height: 24))
                    cell.textLabel?.text = "Plats"
                    cell.detailTextLabel?.text = self.event.location
                }
                
                // MARK : - Guest
                if indexPath.row == 3 {
                    //cell.imageView?.image = UIImage.fontAwesomeIcon(name: .heart, textColor: .darkGray, size: CGSize(width: 24, height: 24))
                    cell.textLabel?.text = "Artist"
                    cell.detailTextLabel?.text = self.event.guest
                }
                
                return cell
                
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
                cell.update(message: event.messages[indexPath.row])
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
        
        
        
        // MARK : - Last row
        if indexPath.section == 2 && indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rounded", for: indexPath) as! RoundedTableViewCell
            cell.backgroundColor = .clear
            cell.textLabel?.text = ""
            cell.selectionStyle = .none
            cell.accessoryView = nil
            cell.corners = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
            return cell
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    // MARK : - Height
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5 && indexPath.section == 1 && self.currentState == .info {
            // return 300
        }
        
        if indexPath.section == 1 && self.currentState == .chat  {
            
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

