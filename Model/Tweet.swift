//
//  Tweet.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

class Tweet {
    weak var follower: Follower?
    var text: String
    var created_at: String
    init(follower: Follower?, text: String, created_at: String) {
        self.follower = follower
        self.text = text
        self.created_at = created_at
    }
}
