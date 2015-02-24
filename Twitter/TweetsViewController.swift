//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/22/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    var tweets: [Tweet]?
    var refreshControl:UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetTableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Fetching Tweets")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.refresh(self)
    }

    @IBAction func onLogout(sender: AnyObject) {
        NSLog("cu: \(User.currentUser)")
        User.currentUser?.logout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(sender:AnyObject)
    {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        self.refreshControl.endRefreshing()
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

// MARK: - TweetCellDelegate
extension TweetsViewController: TweetCellDelegate {
    func favoriteButtonWasPressed(cell: TweetTableViewCell) {
        var indexPath = tableView.indexPathForCell(cell)
        var tweet = tweets![indexPath!.row] as Tweet
        TwitterClient.sharedInstance.favoriteWithId(tweet.id!, block: { (response, error) in
            if let r = response as? NSDictionary {
                println("Tweet \(tweet.id) favorited")
            } else {
                println("Error favoriting \(tweet.id) \(error)")
            }
        })
    }
    
    func retweetButtonWasPressed(cell: TweetTableViewCell) {
        var indexPath = tableView.indexPathForCell(cell)
        var tweet = tweets![indexPath!.row] as Tweet
    }
    
    func replyButtonWasPressed(cell: TweetTableViewCell) {
        var indexPath = tableView.indexPathForCell(cell)
        var tweet = tweets![indexPath!.row] as Tweet
    }
}

// MARK: - UITableViewDataSource
extension TweetsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 20
        }
    }
}

// MARK: - UITableViewDelegate - cell for row
extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetTableViewCell") as TweetTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if self.tweets != nil {
            var tweet = self.tweets![indexPath.row]
            cell.setTweet(tweet)
        }
        cell.delegate = self
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tweet = tweets![indexPath.row]
//        let vc = TweetDetailViewController()
//        vc.tweet = tweet
        
        var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var vc : TweetDetailViewController = storyboard.instantiateViewControllerWithIdentifier("TweetDetail") as TweetDetailViewController
        vc.tweet = tweet
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell.respondsToSelector(Selector("separatorInset"))) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if (cell.respondsToSelector(Selector("preservesSuperviewLayoutMargins"))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if (cell.respondsToSelector(Selector("layoutMargins"))) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}
