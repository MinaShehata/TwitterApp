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
                let user = User(userName: session.userName, berear_token: self.access_token)
                completion(user)
            }
        }
        
        loginButton.center = view.center
        view.addSubview(loginButton)
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
