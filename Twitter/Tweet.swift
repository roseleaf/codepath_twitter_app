//
//  Tweet.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/22/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favorited: Bool?
    var id: String?
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text =  dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Bool
        id = dictionary["id_str"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

    func timeAgoWithDate(date: NSDate) -> String {
        var interval = -date.timeIntervalSinceNow
        var number = 0
        var label = ""
        
        if interval < 60 * 60 {
            number = Int(interval / 60)
            label = "m"
        } else if interval < 60 * 60 * 24 {
            number = Int(interval / 60 / 60)
            label = "h"
        } else if interval < 60 * 60 * 24 * 7 {
            number = Int(interval / 60 / 60 / 24)
            label = "d"
        } else {
            number = Int(interval / 60 / 60 / 24 / 7)
            label = "w"
        }
        
        let timeAgo = "\(number)\(label)"
        return timeAgo
    }
}
