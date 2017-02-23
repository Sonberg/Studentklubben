//
//  NavigationViewController.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-01-30.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Navigation_stack
import ChameleonFramework

class NavigationViewController: NavigationStack {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesNavigationBarHairline = true
        //self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = .white

        // Do any additional setup after loading the view.
    }
}
