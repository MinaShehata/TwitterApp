//
//  helper.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class helper: NSObject {
    
    class func saveCredential(bearer_token: String, username: String)
    {
        // save api_token to user Defaults
        let def = UserDefaults.standard
        def.set(username, forKey: "username")
        def.set(bearer_token, forKey: "bearer_token")
        def.synchronize()
        
        restartApp()
    }
    class func removeCredential() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "username")
        def.removeObject(forKey: "bearer_token")
        def.synchronize()
        restartApp()
    }
    
    // get user as save it
    class func getCredential() -> User? {
        let def = UserDefaults.standard
        if let username = def.object(forKey: "username") as? String, let bearer_token = def.object(forKey: "bearer_token") as? String {
            let user = User(userName: username, bearer_token: bearer_token)
            return user
        }
        return nil
    }
    
    // retart app after login or register
    class func restartApp(){
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Start", bundle: nil)
        var vc :UIViewController
        if getCredential() == nil {
            vc = sb.instantiateInitialViewController()!
        }
        else {
            let sb = UIStoryboard(name: "Followers", bundle: nil)
            vc = sb.instantiateInitialViewController()!
        }
        
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 1, options: [], animations: nil, completion: nil)
    }
    
    
    class func estimateFrameForText(text: String, size: CGFloat) -> CGRect {
        // this attribute must be big than prefered font
        let attribute = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        // this size must be big that real size
        let size = CGSize(width: size, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attribute, context: nil)
    }

    // very important.......... add observer on spacific view controller for Generics
    /// network stuff here we add observer and simple status function on UIViewController Class to alert user that network status changed
    static var connected: Bool = false // for sending requests to server.........
    class func addNetworkObserver(on viewController: UIViewController) {
        NotificationCenter.default.addObserver(viewController, selector: #selector(viewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            connected = false
        case .online(.wwan):
            connected = true
        case .online(.wiFi):
            connected = true
        }
    }
    
    // remove from  viewcontroller when it disappear from window for memory leaks.............
    class func removeNetworkObserver(from viewController: UIViewController) {
        NotificationCenter.default.removeObserver(viewController, name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
    }
    ////////////////// finish network Stuffffffff
    
    /// this valriable for zoming capapility
    static var inZooming = true
    static var image = "banner"
    
    
}
