//
//  Tweet.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

//json response
//{
    //"created_at": "Mon Feb 05 18:02:44 +0000 2018",
    //"id": 960574424717119488,
    //"id_str": "960574424717119488",
    //"text": "RT @isararah_: طرزان بنفسه ما عاشرش كمية الحيوانات اللي انا عاشرتها.",
//}

class Tweet{
  
    private(set) var id: NSNumber
    weak var follower: Follower?
    var text: String
    var created_at: String
    init(id: NSNumber, follower: Follower?, text: String, created_at: String) {
        self.id = id
        self.follower = follower
        self.text = text
        self.created_at = created_at
    }
}

