//
//  ViewController.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/21/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil {
                User.currentUser = user
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}

