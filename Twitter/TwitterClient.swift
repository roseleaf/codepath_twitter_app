//
//  TwitterClient.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/21/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

let twitterConsumerKey =       "d3NjExmOENuQZ6l1yVck5m0mW"
let twitterConsumerSecret =    "vsYYj2Y8rwOSCcLuTBfp1o8K3Tq4TJY2uuvMYhf5GAfM447MRu"
let twitterConsumerBaseURL =   NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance =         TwitterClient(baseURL: twitterConsumerBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            println("got token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println("failed to get token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            println("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                println("Current user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Error getting user: \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            println("tweets: \(response)")
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error fetching tweets \(error)")
                completion(tweets: nil, error: error)
        })
    }
    
    func composeTweetwithText(text: String, block: (AnyObject?, NSError?) -> Void) {
        let params = [
            "status": text
        ]
        
        POST("1.1/statuses/update.json", parameters: params, success: { (request, response) in
            block(response, nil)
            }, failure: { (request, error) in
                block(nil, error)
        })
    }
    
    func retweetWithId(id: String, block: (AnyObject?, NSError?) -> Void) {
        let path = "1.1/statuses/retweet/\(id).json"
        POST(path, parameters: nil, success: { (request, response) in
            block(response, nil)
            }, failure: { (request, error) in
                block(nil, error)
        })
    }
    
    func favoriteWithId(id: String, block: (AnyObject?, NSError?) -> Void) {
        let params = [
            "id": id
        ]
        
        POST("1.1/favorites/create.json", parameters: params, success: { (request, response) in
            block(response, nil)
            }, failure: { (request, error) in
                block(nil, error)
        })
    }
}
