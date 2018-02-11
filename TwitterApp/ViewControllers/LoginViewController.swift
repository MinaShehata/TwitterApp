//
//  ViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class LoginViewController: BaseVC {
    
    @IBOutlet weak private var twitterLogoImageView: UIImageView! {
        didSet
        {
            // for using tint color didn't work from interface builder xcode bug.
            twitterLogoImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            twitterLogoImageView.image = #imageLiteral(resourceName: "Tweeter logo")
        }
    }
    
    @IBOutlet weak private var twitterTitleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        langSegmentControl.selectedSegmentIndex = Language.currentLanguage() == "ar" ? 1 : 0
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
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.twitterTitleLabel.alpha = 1
            self.twitterLogoImageView.alpha = 1
        })
        
    }
    
    @IBOutlet weak var langSegmentControl: UISegmentedControl!
    
    @IBAction func ChangeLanguage(_ sender: UISegmentedControl) {
        if  Language.currentLanguage() == "ar"
        {
            langSegmentControl.selectedSegmentIndex = 0
            Language.setAppLanguage(lang: "en-US")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else
        {
            langSegmentControl.selectedSegmentIndex = 1

            Language.setAppLanguage(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        let mainWindow = (UIApplication.shared.delegate as? AppDelegate)?.window
        
        let sb = UIStoryboard(name: "Start", bundle: nil)
        mainWindow?.rootViewController = sb.instantiateViewController(withIdentifier: "rootVC")
        UIView.transition(with: mainWindow!, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
    }
}

