//
//  FollowersController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// loader class for network tasks just ..........
final class Loader {
    // return with next page and fowllowers on that page else fail return error
    class func getAllFollowersFromServer(cursor: Int64, withURL url: String, parameter: [String: Any], token: HTTPHeaders, completion: @escaping (_ followers: [Follower]?, _ success: Bool?, _ error: Error?, _ next_cursor: Int64) -> ()) {
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: token)
        .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let dataArr = json["users"].array else {
                        return
                    }
                    var followers = [Follower]()
                    for data in dataArr {
                        if let data = data.dictionary , let follower = Follower(dict: data) {
                            followers.append(follower)
                        }
                    }
                    let next_cursor = json["next_cursor"].int64 ?? cursor
                    print("next_cursor is \(next_cursor)---------")
                    completion(followers,true, nil, next_cursor)
                    
                case .failure(let error):
                    completion(nil,false, error, cursor)
                }
        }
    }
    // return with last 10 tweets of that user .....
    class func getLastTenTweetForFollower(_ follower: Follower, withURL url: String, parameter: [String: String], token: HTTPHeaders, completion: @escaping (_ tweets: [Tweet]?, _ success: Bool?, _ error: Error?) -> ()) {
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: token)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard let dataArr = json["statuses"].array else {
                        return
                    }
                    var tweets = [Tweet]()
                    for data in dataArr {
                        if let data = data.dictionary , let tweet = Tweet(dict: data, follower: follower) {
                            tweets.append(tweet)
                        }
                    }
                    completion(tweets,true, nil)
                case .failure(let error):
                    completion(nil,false, error)
                }
        }
    }
    
}
