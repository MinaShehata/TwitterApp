//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/6/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionReusableView {

    @IBOutlet weak var profile_banner_imageView: customImageView!
    @IBOutlet weak var profile_picture_imageView: customImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var followingButton: UIButtonX! {
        didSet {
            followingButton.setImage(#imageLiteral(resourceName: "FollowerCheckButton"), for: .normal)
            followingButton.imageView?.contentMode = .scaleAspectFit
            followingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }
    
    func setupHeader(with follower: Follower) {
        if let url = follower.profile_banner_url, let banner_URL = URL(string: url) {
            profile_banner_imageView.loadProfileImageWithUrl(url: banner_URL)
        }
        if let url = follower.profile_picture_URL, let profile_URL = URL(string: url) {
            profile_picture_imageView.loadProfileImageWithUrl(url: profile_URL)
        }
        if let bio = follower.bio {
            bioTextView.text = bio
        }
        userNameLabel.text = follower.userName
        handleLabel.text = "@\(follower.handle)"
    }

}









