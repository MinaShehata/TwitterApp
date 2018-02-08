//
//  AuthController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation
import TwitterKit

final class AuthController: NSObject {

    class func signedIn(view: UIView, with completion: @escaping (User) -> ()) {
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
    
    
    // store access token of user
    private static var access_token = ""
    // shared session
    static let  session: URLSession = .shared
    // MARK:- get Bearer Token for oauth 2.0  to save in user defaults
    // private because no I didn't want any body get token Outside this class.
    private static func getBearerToken() {
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
    
}
