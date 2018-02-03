//
//  ViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/3/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoginButton()
    }
    
    func setupLoginButton() {
        API.shared.signedIn(view: view) { (user) in
            print(user)
        }
    }
    
}

