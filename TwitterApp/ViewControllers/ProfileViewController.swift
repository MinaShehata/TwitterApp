//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var follower: Follower?
    
    
    // some Outlets for View
    @IBOutlet weak var profile_banner_imageView: customImageView!
    @IBOutlet weak var profile_picture_imageView: customImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        if let follower = follower {
            if let profile_banner_url = follower.profile_banner_url, let followerBannerURL = URL(string: profile_banner_url){
                profile_banner_imageView.loadProfileImageWithUrl(url: followerBannerURL)
            }
            if let rofile_picture_URL = follower.profile_picture_URL, let followerProfilePictureURL = URL(string: rofile_picture_URL) {
                profile_picture_imageView.loadProfileImageWithUrl(url: followerProfilePictureURL)
            }
            userNameLabel.text = follower.userName
            handleLabel.text = "@\(follower.handle)"
            // bio text
        }
    }
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
