//
//  UserViewController.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-21.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import LatoFont
import DynamicButton

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK  : - Action
    func close() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    // MARK : - Variables
    let screen = UIScreen.main.bounds
    let kTableViewHeaderHeight : CGFloat = 500.0
    var headerView : UIView!
    var backButton : DynamicButton = DynamicButton(style: DynamicButtonStyle.arrowLeft)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        setupHeaderView()
        
        self.navigationItem.title = "Per Sonberg"
        self.setTableViewBackgroundGradient(topColor: .clear, bottomColor: UIColor(averageColorFrom: #imageLiteral(resourceName: "43539")))
        
        
        // MARK : - Back button
        backButton = DynamicButton(style: DynamicButtonStyle.arrowLeft)
        backButton.strokeColor = .white
        backButton.frame = CGRect(x: 16, y: 40, width: 18, height: 18)
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        self.view.addSubview(backButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.reloadData()
        
        // MARK : - Show headerView
        UIView.animate(withDuration: 0.6) {
            if let image : UIImageView = self.headerView.subviews.first as! UIImageView? {
                image.alpha = 1
            }
        }
    }
 
    // MARK : - Header View Image
    func setupHeaderView() {
        
        headerView = tableView.tableHeaderView
        for view in headerView.subviews {
            if view is UIImageView {
                let imageView : UIImageView = view as! UIImageView
                imageView.image = #imageLiteral(resourceName: "43539")
                //imageView.hnk_setImageFromURL(URL(string: event.url)!)
                let color = UIColor(averageColorFrom: imageView.image!)
                headerView.backgroundColor = color
                tableView.backgroundColor = color
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
    
    
    
    // MARK : - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "PER SONBERG"
            cell.textLabel?.font = UIFont(name: "Futura-Bold", size: 26.0)
            cell.textLabel?.textColor = .flatBlack
            cell.textLabel?.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        }
        
        if indexPath.row > 0 && indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.font = UIFont.lato(size: 16)
            cell.textLabel?.textColor = .flatBlack
            cell.detailTextLabel?.textColor = .clear
            cell.selectionStyle = .none
            cell.accessoryView = nil
            cell.layer.roundCorners(.allCorners, radius: 0)
            
            // MARK : - Location
            if indexPath.row == 1 {
                cell.imageView?.image = UIImage.init(icon: FontType.linearIcons(LinearIconType.mapMarker), size: CGSize(width: 18, height: 18), textColor: .flatBlack, backgroundColor: .clear)
                cell.textLabel?.text = "Kalmar"
            }
            
            return cell
        }

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 32
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
       
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    // MARK : - Gradient
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
