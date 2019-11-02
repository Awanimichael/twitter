//
//  LoginViewController.swift
//  Twitter
//
//  Created by Rotimi Awani on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        //Check for authorization and direct to home screen
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn") //This is to store true when user has logged in
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Error in login")
        })
    }
    

}
