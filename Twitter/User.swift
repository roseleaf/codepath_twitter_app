//
//  User.swift
//  Twitter
//
//  Created by Rose Trujillo on 2/22/15.
//  Copyright (c) 2015 Rose Trujillo. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary?
    var HRProfileImageURL: String?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        var screenNameString = dictionary["screen_name"] as? String
        screenname = "@\(screenNameString!)"
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["desciprtion"] as? String
        HRProfileImageURL = profileImageURL!.stringByReplacingOccurrencesOfString("_normal.png", withString: "_bigger.png")
        self.dictionary = dictionary
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                   var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}
