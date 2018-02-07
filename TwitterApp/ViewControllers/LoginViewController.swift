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
            twitterLogoImageView.tintColor = #colorLiteral(red: 0.2514260113, green: 0.4632044435, blue: 0.6128600836, alpha: 1)
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
        AuthController.signedIn(view: view) { (user) in
            print(user)
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

