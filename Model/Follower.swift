//
//  Follower.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import SwiftyJSON

class Follower: NSObject, NSCoding {
   
    var userName: String
    var handle: String
    var bio: String?
    var profile_picture_URL: String?
    var profile_banner_url: String?
    let profile_picture_id: String?
    let banner_picture_id: String?
    var tweets: [Tweet]?
    
    init?(dict: [String: JSON]) {
        guard let username = dict["name"]?.stringValue, let handle = dict["screen_name"]?.stringValue else { return nil }
        self.userName = username
        self.handle = handle
        self.tweets = nil
        self.bio = dict["description"]?.string
        self.profile_banner_url = dict["profile_banner_url"]?.string
        self.profile_picture_URL = dict["profile_image_url_https"]?.string
        self.profile_picture_id = profile_picture_URL != nil ? UUID().uuidString : nil
        self.banner_picture_id = profile_banner_url != nil ? UUID().uuidString : nil
    }
    
    // persistance stuff..................
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(handle, forKey: "handle")
        aCoder.encode(bio, forKey: "bio")
        aCoder.encode(profile_picture_id, forKey: "profile_picture_id")
        aCoder.encode(banner_picture_id, forKey: "banner_picture_id")
        aCoder.encode(profile_picture_URL, forKey: "profile_picture_URL")
        aCoder.encode(profile_banner_url, forKey: "profile_banner_url")
        aCoder.encode(tweets, forKey: "tweets")
    }

    required init?(coder aDecoder: NSCoder) {
        userName = aDecoder.decodeObject(forKey: "userName") as! String
        handle = aDecoder.decodeObject(forKey: "handle") as! String
        bio = aDecoder.decodeObject(forKey: "bio") as! String?
        profile_picture_URL = aDecoder.decodeObject(forKey: "profile_picture_URL") as! String?
        profile_banner_url = aDecoder.decodeObject(forKey: "profile_banner_url") as! String?
        profile_picture_id = aDecoder.decodeObject(forKey: "profile_picture_id") as! String?
        banner_picture_id = aDecoder.decodeObject(forKey: "banner_picture_id") as! String?
        tweets = aDecoder.decodeObject(forKey: "tweets") as! [Tweet]?
        super.init()
    }
    
}
