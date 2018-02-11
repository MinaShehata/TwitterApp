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
    
    
    // here we ask loader class to get some followers to us to present them to View controller
    // page defaults to -1
    func followers(cursor: Int64 = -1, completion: @escaping (_ followers: [Follower]?, _ next_cursor: Int64, _ error :Error?) -> ()) {
        let url = Constants.followers
        if let user = helper.getCredential() {
            let parameter: [String: String] = ["screen_name": user.userName, "cursor": "\(cursor)", "count": "10"] // 10 per page
            let token = ["Authorization" :"Bearer " + user.bearer_token]
            Loader.getAllFollowersFromServer(cursor: cursor, withURL: url, parameter: parameter, token: token, completion: { (followers, success, error, next_cursor) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, next_cursor, error)
                    return
                }
              
                if let fs = followers {
                    FollowerStore.shared.append(with: fs)
                    DispatchQueue.main.async {
                        completion(fs, next_cursor, nil)
                    }
                }
            })
        }
    }
    // here we ask loader class to get last 10 tweets to us to present them to View controller
    func tweets(of follower: Follower,completion: @escaping ([Tweet]?, _ error: Error?) -> ()) {
        let url = Constants.tweets
        if let user = helper.getCredential() {
            let parameter = ["q": "@\(follower.handle)", "count": "10"] // last 10 tweets........
            let token = ["Authorization" :"Bearer " + user.bearer_token]
            Loader.getLastTenTweetForFollower(follower, withURL: url, parameter: parameter, token: token, completion: { (tweets, success, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                    return
                }
                if let tw = tweets {
                    FollowerStore.shared.setTweets(of: follower, with: tw)
                    DispatchQueue.main.async {
                        completion(tw, nil)
                    }
                }
            })
        }
    }
    
}
