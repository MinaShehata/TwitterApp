//
//  Follower.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

class Follower {
    var userName: String
    var handle: String
    var bio: String?
    var profile_picture_URL: String?
    var profile_banner_url: String?
    init(userName: String, handle: String, bio: String?, profile_picture_URL: String?, profile_banner_url: String?) {
        self.userName = userName
        self.handle = handle
        self.bio = bio
        self.profile_picture_URL = profile_picture_URL
        self.profile_banner_url = profile_banner_url
    }
}
