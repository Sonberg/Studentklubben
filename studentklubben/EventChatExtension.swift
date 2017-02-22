//
//  EventChatExtension.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-18.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Foundation
import FontAwesome_swift

extension EventViewController {
    // MARK : - Screenshot
    func detectScreenshot()  {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue, using: { notification in
            if self.currentState == .chat {
                let message = Message()
                message.type = .screenshot
                message.user = "me"
                message.save(eventId: self.event.id)
            }
            
        })
    }
    
    
    
    // MARK : - Chat field
    
    
    func chatField() -> UIView {
        self.inputTextField.delegate = self
        self.inputTextField.setLeftPaddingPoints(6)
        self.inputTextField.textColor = .darkGray
        self.inputTextField.attributedPlaceholder = NSAttributedString(string: "Skriv ett medelande...",
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
        self.inputTextField.font = UIFont.systemFont(ofSize: 14)
        
        setNeedsStatusBarAppearanceUpdate()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        let sendButton = self.sendButton()
        sendButton.addTarget(self, action: #selector(sendMessage), for: UIControlEvents.touchUpInside)
        
        
        let messageInputContainerView: UIView = UIView(frame: CGRect(x: 6, y: self.screen.height, width: UIScreen.main.bounds.width - 12, height: 44))
        messageInputContainerView.backgroundColor = UIColor.white
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
        button.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.paperPlane, textColor: .darkGray, size: CGSize(width: 22, height: 22)), for: .normal)
        button.setImage(UIImage.fontAwesomeIcon(name: FontAwesome.paperPlaneO, textColor: .darkGray, size: CGSize(width: 24, height: 24)), for: UIControlState.highlighted)
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
