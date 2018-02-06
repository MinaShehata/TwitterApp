//
//  ViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak private var twitterLogoImageView: UIImageView! {
        didSet
        {
            // for using tint color didn't work from interface builder xcode bug.
            twitterLogoImageView.image = #imageLiteral(resourceName: "Tweeter logo")
        }
    }
    
    @IBOutlet weak private var twitterTitleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAnimation()
        setupLoginButton()
        
    }
    
    final private func setupLoginButton() {
        API.shared.signedIn(view: view) { (user) in
            helper.saveCredential(bearer_token: user.bearer_token, username: user.userName)
        }
    }
    
    final private func setupAnimation(){
        twitterTitleLabel.alpha = 0
        twitterLogoImageView.alpha = 0
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.twitterTitleLabel.alpha = 1
            self.twitterLogoImageView.alpha = 1
        })
        
    }
    
}

