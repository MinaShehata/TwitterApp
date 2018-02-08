//
//  UIViewController+Extension.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert (title :String , message:String , okTitle: String = "Ok" , Okhandler: ((UIAlertAction)->())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: Okhandler))
        self.present(alert, animated: true, completion: nil)
    }
}
