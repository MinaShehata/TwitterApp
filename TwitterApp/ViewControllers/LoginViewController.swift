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
    
    @IBOutlet weak private var twitterTitleLabel: UILabel! {
        didSet {
            twitterTitleLabel.text = NSLocalizedString("Twitter", comment: "change Logo Name")
        }
    }
    
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
    
    @IBOutlet weak var langSegmentControl: UISegmentedControl!
    
    @IBAction func ChangeLanguage(_ sender: UISegmentedControl) {
        if  Language.currentLanguage() == "ar"
        {
            twitterLogoImageView.tintColor = #colorLiteral(red: 0.1365008056, green: 0.276440084, blue: 0.360370636, alpha: 1)
            langSegmentControl.selectedSegmentIndex = 0
            Language.setAppLanguage(lang: "en-US")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        else
        {
            langSegmentControl.selectedSegmentIndex = 1
            twitterLogoImageView.tintColor = #colorLiteral(red: 0.3219999969, green: 0.5429999828, blue: 0.4979999959, alpha: 1)

            Language.setAppLanguage(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        let mainWindow = (UIApplication.shared.delegate as? AppDelegate)?.window
        
        let sb = UIStoryboard(name: "Start", bundle: nil)
        mainWindow?.rootViewController = sb.instantiateViewController(withIdentifier: "rootVC")
        
        UIView.transition(with: mainWindow!, duration: 0.5, options: [.transitionFlipFromLeft], animations: nil, completion: nil)
        
    }
}

