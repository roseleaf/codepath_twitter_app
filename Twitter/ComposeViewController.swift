//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/23/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeTextField: UITextView!
    @IBAction func submitButtonPressed(sender: AnyObject) {
        let tweetText = composeTextField.text
        TwitterClient.sharedInstance.composeTweetwithText(composeTextField.text) { (response, error) in
            if let r = response as? NSDictionary {
                println("Tweeted \(r)")
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                println("Error tweeting \(error)")
            }
        }
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
