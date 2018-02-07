//
//  Tweet.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import  SwiftyJSON

//json response
//{
    //"created_at": "Mon Feb 05 18:02:44 +0000 2018",
    //"id": 960574424717119488,
    //"id_str": "960574424717119488",
    //"text": "RT @isararah_: طرزان بنفسه ما عاشرش كمية الحيوانات اللي انا عاشرتها.",
//}

class Tweet: NSObject, NSCoding {
   
    weak var follower: Follower?
    var text: String
    var created_at: String
    init?(dict: [String: JSON],follower: Follower?) {
        guard let text = dict["text"]?.stringValue, let created_at = dict["created_at"]?.string else { return nil }
        self.follower = follower
        self.text = text
        self.created_at = created_at.formatDateFromServer()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(follower, forKey: "follower")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(created_at, forKey: "created_at")
    }
    
    required init?(coder aDecoder: NSCoder) {
        follower = aDecoder.decodeObject(forKey: "follower") as! Follower?
        text = aDecoder.decodeObject(forKey: "text") as! String
        created_at = aDecoder.decodeObject(forKey: "created_at") as! String
        super.init()
    }
}

