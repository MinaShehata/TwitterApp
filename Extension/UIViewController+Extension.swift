//
//  UIViewController+Extension.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

// show error when network is offline if error in saving etc..........
extension UIViewController {
    func showAlert (title :String , message:String , okTitle: String = "Ok" , Okhandler: ((UIAlertAction)->())? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: Okhandler))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// inhertance this class and code refactoring........
class BaseVC: UIViewController {
    // for persistance needs
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper.addNetworkObserver(on: self)
    }

    // for network status listner
    @objc func networkStatusChanged(_ notification: Notification) {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("offline")
            showNetworkStatusView(text: "offline", status: false)
        case .online(.wwan):
            print("online")
            showNetworkStatusView(text: "online", status: true)
        case .online(.wiFi):
            print("online")
            showNetworkStatusView(text: "online", status: true)
        }
    }
    lazy var statusView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 35))
        return view
    }()
    // variadic parameter and text.........
    func showNetworkStatusView(text: String, status: Bool) {
        let netstatus = Reach().connectionStatus()
        switch netstatus {
        case .unknown, .offline: statusView.backgroundColor = #colorLiteral(red: 0.9331166148, green: 0.2054923475, blue: 0.3118382692, alpha: 1)
        case .online(.wwan): statusView.backgroundColor = #colorLiteral(red: 0.1365008056, green: 0.276440084, blue: 0.360370636, alpha: 1)
        case .online(.wiFi): statusView.backgroundColor = #colorLiteral(red: 0.1365008056, green: 0.276440084, blue: 0.360370636, alpha: 1)
        }
        guard let window = UIApplication.shared.keyWindow else { return }
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
        if status {
            statusView.removeFromSuperview()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        helper.removeNetworkObserver(from: self)
        statusView.removeFromSuperview()
        helper.clickableProfileImageView = nil
        helper.clickableBannerImageView = nil
    }
    
}


