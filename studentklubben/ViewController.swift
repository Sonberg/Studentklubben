//
//  ViewController.swift
//  maprun
//
//  Created by Per Sonberg on 2017-01-26.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase
import FontAwesome_swift
import BTNavigationDropdownMenu

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    
    // MARK : - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK : - Actions
    func didTouchUser(_ sender : Any) {
        self.performSegue(withIdentifier: "userSegue", sender: self)
    }
    
    // MARK : - Varables
    let transtition = SwiftyExpandingTransition()
    var selectedCellFrame : CGRect = .zero
    var events : [Event] = []
    let screen = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebase()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        view.backgroundColor = UIColor.white
        let userButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        userButton.setImage(UIImage.init(icon: FontType.linearIcons(LinearIconType.user), size: CGSize(width: 24, height: 24), textColor: .darkGray, backgroundColor: .clear), for: .normal)
        userButton.addTarget(self, action: #selector(didTouchUser(_:)), for: .touchUpInside)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: userButton), animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Studentklubben"
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK : - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CardTableViewCell
        cell.event = self.events[indexPath.row]
        
        // MARK : - Going State
        if self.events[indexPath.row].going.contains("me") {
            let check = UIImage.fontAwesomeIcon(name: FontAwesome.check, textColor: .white, size: CGSize(width: 22, height: 22))
            //cell.accessoryView  = UIImageView(image: check)
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardTableViewCell
        self.selectedCellFrame = tableView.convert(cell.frame, to: tableView.superview)
        self.performSegue(withIdentifier: "eventSegue", sender: self)

    }
    
    // MARK : - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.delegate = self
        self.navigationItem.title = ""
        
        if let indexPath =  self.tableView.indexPathForSelectedRow {
            let vc = segue.destination as! EventViewController
            vc.event = self.events[indexPath.row]
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
            transtition.operation = UINavigationControllerOperation.push
            transtition.duration = 0.40
            transtition.selectedCellFrame = self.selectedCellFrame
            
            return transtition
        }
        
        if operation == UINavigationControllerOperation.pop {
            transtition.operation = UINavigationControllerOperation.pop
            transtition.duration = 0.20
            
            return transtition
        }
        
        return nil
    }
    
    
    
    func townMenu()  {
        let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Dropdown Menu", items: items as [AnyObject])
        
        menuView.cellBackgroundColor = .flatWhite

        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: menuView), animated: true)
        
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
        }
    }
   
}


// MARK : - Firebase
extension ViewController {
    func firebase()  {
        let ref = FIRDatabase.database().reference().child("events")
        
        ref.observe(FIRDataEventType.childAdded) { (snap : FIRDataSnapshot) in
            self.events.append(Event(snap: snap))
            self.tableView.reloadData()
        }
        
        ref.observe(FIRDataEventType.childChanged) { (snap : FIRDataSnapshot) in
            let event = Event(snap: snap)
            for index in 0...self.events.count - 1 {
                if self.events[index].id == event.id {
                    self.events[index] = event
                    self.tableView.reloadData()
                }
            }

        }
        
        ref.observe(FIRDataEventType.childRemoved) { (snap : FIRDataSnapshot) in
            for index in 0...self.events.count - 1 {
                if self.events[index].id == snap.key {
                    self.events.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
}

