//
//  Constants.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

// this class contain all constants through our project 
class Constants {
    static let consumerKey = "tIGC04jlRQINK9psdsEyPg6GI"
    static let consumerSecret = "vLqhm04cyRrW7jeKMgwrX5ukyNsKyHOrrZSkKX56AXzJhOQ9MW"
    
    // cellID
    static let FollowerCell = "FollowerCell" // for collectionView
    static let ProfileHeader = "ProfileHeader" // for collectionView profile Header
    static let TweetCell = "TweetCell" // for collectionView Tweet Cell
    //
    
    // segue identifier
    static let follower_profile_data = "follower_profile_data"
    
    // some constants to get bearer token
    static let post = "POST"
    static let get = "GET"
    static let grantType =  "grant_type=client_credentials"
    
    
    // host URL that contain Berear Token.....
    static let token = "https://api.twitter.com/oauth2/token"
    
    // Main URL For API
    static let main = "https://api.twitter.com/1.1/"
    
    // get Followers of User { GET query[handle of user]}
    static let followers = main + "followers/list.json"
    // get last ten tweets of follower { get query[handle of follower]}
    static let tweets = main + "search/tweets.json"
}
