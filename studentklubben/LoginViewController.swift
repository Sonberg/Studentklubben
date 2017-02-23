//
//  LoginViewController.swift
//  studentklubben
//
//  Created by Per Sonberg on 2017-02-23.
//  Copyright © 2017 Per Sonberg. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // MARK : - Variables
    var user : User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.tooltipBehavior = .automatic
        loginButton.center = self.view.center
        view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }
    
    

    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            
            if let error = error {
                return print(error)
            }
            
            if user != nil {
                self.user = User(snap: user!)
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
