//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/22/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func favoriteButtonWasPressed(cell: TweetTableViewCell)
    func retweetButtonWasPressed(cell: TweetTableViewCell)
    func replyButtonWasPressed(cell: TweetTableViewCell)
}

class TweetTableViewCell: UITableViewCell {
    var delegate: TweetCellDelegate!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBAction func onReplyPressed(sender: AnyObject) {
        NSLog("reply")
    }
    @IBAction func onRetweetPressed(sender: AnyObject) {
        NSLog("retweet")
    }

    @IBAction func onFavoritePressed(sender: AnyObject) {
        NSLog("heart")
        heartButton.setImage( UIImage(named: "heart-red.png"), forState: UIControlState.Normal)
        delegate.favoriteButtonWasPressed(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentLabel.preferredMaxLayoutWidth = 220
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setTweet(tweet: Tweet) {
        nameLabel.text = tweet.user!.name as String!
        screennameLabel.text = tweet.user!.screenname as String!
        contentLabel.text = tweet.text as String!
        createdAtLabel.text = tweet.timeAgoWithDate(tweet.createdAt as NSDate!)
        profileImageView.setImageWithURL( NSURL(string: tweet.user!.HRProfileImageURL! as String))
        
        if tweet.favorited == true {
            heartButton.setImage( UIImage(named: "heart-red.png"), forState: UIControlState.Normal)
        }
    }
    
    
}
