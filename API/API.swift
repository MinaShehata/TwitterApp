//
//  TwitterServiceWrapper.swift
//  TwitterClient
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import TwitterKit

//facade Pattern (Main Class that manage the user Interaction With System)
final class API
{
    // singleton Object to manage Api operations from One place...
    static let shared = API()
    private init(){} // private initializer to make sure that class will not initialize from any other Place....
    
    // store access token of user
    private var access_token = ""

    let session: URLSession = .shared
    // MARK:- get Bearer Token for oauth 2.0  to save in user defaults
    // private because no I didn't want any body get token Outside this class.
    private func getBearerToken() {
        guard let tokenURL = URL(string: Constants.token) else { return }
        //////////////////////////
        // construct Our Request that send to twitter Authentication Server
        var request = URLRequest(url: tokenURL)
        request.httpMethod = Constants.post
        request.addValue("Basic " + "".getBase64EncodeString(consumerKey: Constants.consumerKey, and: Constants.consumerSecret), forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = Constants.grantType.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // start session
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if let access_token = json["access_token"] as? String
                    {
                        self.access_token = access_token
                    }
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func signedIn(view: UIView, with completion: @escaping (User) -> ()) {
        getBearerToken()
        let loginButton = TWTRLogInButton { (session, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let session = session {
                let user = User(userName: session.userName, bearer_token: self.access_token)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2), execute: {
                    completion(user)
                })
            }
        }
        
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    
    func getFollowers(url: URL, bearer: String, completion: @escaping ([Follower]?) -> ()) {
        var followers = [Follower]()
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.get
        // this header required for oauth 2.0 twitter Authentication
        let token = "Bearer " + bearer
        request.addValue(token, forHTTPHeaderField: "Authorization")
        //
        let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let results = json as? [String: Any] {
                    if let users = results["users"] as? [[String: Any]] {
                        for follower in users {
                            guard let userName = follower["name"] as? String, let handle = follower["screen_name"] as? String else { return }
                            let bio = follower["description"] as? String
                            let profile_picture_URL = follower["profile_image_url_https"] as? String
                            let profile_banner_url = follower["profile_banner_url"] as? String
                            let flwr = Follower(userName: userName, handle: handle, bio: bio, profile_picture_URL: profile_picture_URL, profile_banner_url: profile_banner_url)
                            followers.append(flwr)
                            
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(followers)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    func getFollowerLastTenTweets(follower: Follower, url: URL, bearer: String, completion: @escaping ([Tweet]?) -> ()) {
        var tweets = [Tweet]()
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.get
        // this header required for oauth 2.0 twitter Authentication
        let token = "Bearer " + bearer
        request.addValue(token, forHTTPHeaderField: "Authorization")
        //
        let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let json = json as? [String: Any], let status = json["statuses"] as? [[String: Any]] {
                    for st in status {
                        if let text = st["text"] as? String, let created_at = st["created_at"] as? String {
                            let tweet = Tweet(follower: follower, text: text, created_at: created_at)
                            tweets.append(tweet)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(tweets)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    
    
//    func getResponseForRequest(url: URL) {
//
//        getBearerToken(completion: { (bearer) in
//
//            var request = URLRequest(url: url)
//            request.httpMethod = Constants.get
//
//            let token = "Bearer " + bearer
//            request.addValue(token, forHTTPHeaderField: "Authorization")
//
//            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let data = data else { return }
//
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let results = json as? [String: Any] {
//                        let users = results["users"]as? [[String: Any]]
//                        print(users![3]["name"])
//                    }
//                }
//                catch {
//                    print(error.localizedDescription)
//                }
//
//            })
//            task.resume()
//        })
//    }
    
}
