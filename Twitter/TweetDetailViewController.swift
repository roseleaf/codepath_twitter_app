//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/23/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextView!
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
    }
    @IBOutlet weak var retweetButtonPressed: UIButton!
    @IBAction func replyButtonPressed(sender: AnyObject) {
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTweet(tweet!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTweet(tweet: Tweet) {
        nameLabel.text = tweet.user!.name as String!
        screennameLabel.text = tweet.user!.screenname as String!
        contentTextField.text = tweet.text as String!
        createdAtLabel.text = tweet.timeAgoWithDate(tweet.createdAt as NSDate!)
        profileImageView.setImageWithURL( NSURL(string: tweet.user!.HRProfileImageURL! as String))
        
        if tweet.favorited == true {
            heartButton.setImage( UIImage(named: "heart-red.png"), forState: UIControlState.Normal)
        }
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
