//
//  TwitterServiceWrapper.swift
//  TwitterClient
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

//facade Pattern (Main Class that manage the user Interaction With System)
final class API
{
    // singleton Object to manage Api operations from One place...
    static let shared = API()
    private init(){} // private initializer to make sure that class will not initialize from any other Place....
    
    // reference for persistance
    var followerStore = FollowerStore()
    
    // page defaults to 1
    func followers(current_cursor: Int = -1, completion: @escaping (_ followers: [Follower]?, _ previous_cursor: Int) -> ()) {
        let url = Constants.followers
        if let user = helper.getCredential() {
            let parameter: [String: String] = ["screen_name": user.userName, "cursor": "\(current_cursor)", "count": "10"]
            let token = ["Authorization" :"Bearer " + user.bearer_token]
            Loader.getAllFollowersFromServer(cursor: current_cursor, withURL: url, parameter: parameter, token: token, completion: { (followers, success, error, next_cursor) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, current_cursor)
                    return
                }
                if let fs = followers {
                    self.followerStore.append(with: fs) // save in background thread
                    DispatchQueue.main.async {
                        completion(fs, next_cursor)
                    }
                }
            })
        }
    }
    
    func tweets(of follower: Follower,completion: @escaping ([Tweet]?) -> ()) {
        let url = Constants.tweets
        if let user = helper.getCredential() {
            let parameter = ["q": "@\(follower.handle)", "count": "10"] // last 10 tweets........
            let token = ["Authorization" :"Bearer " + user.bearer_token]
            Loader.getLastTenTweetForFollower(follower, withURL: url, parameter: parameter, token: token, completion: { (tweets, success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let tw = tweets {
                    self.followerStore.setTweets(of: follower, with: tw) // save in background thread
                    DispatchQueue.main.async {
                        completion(tw)
                    }
                }
            })
        }
    }
    
}
