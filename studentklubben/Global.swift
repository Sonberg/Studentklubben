//
//  Global.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-06.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Foundation

extension CALayer {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

extension UIView {
    func roundCorners() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 18.0, height: 0.0))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

class InsetLabel: UILabel
{
    @IBInspectable var topInset = CGFloat(4)
    @IBInspectable var bottomInset = CGFloat(4)
    @IBInspectable var leftInset = CGFloat(16)
    @IBInspectable var rightInset = CGFloat(16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func setInset(top : CGFloat, left : CGFloat, bottom : CGFloat, right : CGFloat) {
        self.topInset = top
        self.leftInset = left
        self.bottomInset = bottom
        self.rightInset = right
    }
 
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    func showMenu(_ sender: AnyObject?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy) {
            return true
        }
        return false
    }
    
    
    override func drawText(in rect: CGRect)
    {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    
    
    
    override open var intrinsicContentSize: CGSize
    {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}


extension UILabel {
    convenience init(badgeText: String, color: UIColor = UIColor.red, fontSize: CGFloat = UIFont.smallSystemFontSize) {
        self.init()
        text = " \(badgeText) "
        textColor = UIColor.white
        backgroundColor = color
        
        font = UIFont.systemFont(ofSize: fontSize)
        layer.cornerRadius = fontSize * CGFloat(0.6)
        clipsToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension Date {
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
