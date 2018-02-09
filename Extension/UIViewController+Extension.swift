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
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            showNetworkStatusView(text: "offline")
        case .online(.wwan): break
        case .online(.wiFi): break
        }
    }
    // variadic parameter and text.........
    func showNetworkStatusView(text: String) {
        guard let window = UIApplication.shared.keyWindow else { return }
        
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: window.frame.width, height: 30))
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline: statusView.backgroundColor = #colorLiteral(red: 0.9331166148, green: 0.2054923475, blue: 0.3118382692, alpha: 1)
        case .online(.wwan): statusView.backgroundColor = #colorLiteral(red: 0.1365008056, green: 0.276440084, blue: 0.360370636, alpha: 1)
        case .online(.wiFi): statusView.backgroundColor = #colorLiteral(red: 0.1365008056, green: 0.276440084, blue: 0.360370636, alpha: 1)
        }
        window.addSubview(statusView)
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        statusView.addSubview(label)
        label.topAnchor.constraint(equalTo: statusView.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: statusView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: statusView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: statusView.bottomAnchor).isActive = true
        statusView.alpha = 0
        setupAnimation(view: statusView)
    }
    private func setupAnimation(view: UIView) {
        UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut], animations: {
            view.alpha = 1
        }) { (granted) in
            view.removeFromSuperview()
        }
    }
    
    
}
