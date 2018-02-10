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
    
    @IBOutlet weak var followingButton: UIButtonX! {
        didSet {
            followingButton.setImage(#imageLiteral(resourceName: "FollowerCheckButton"), for: .normal)
            followingButton.imageView?.contentMode = .scaleAspectFit
            followingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }
    
    
    func setupHeader(with follower: Follower) {
        
        if helper.connected {
            if let url = follower.profile_banner_url {
                profile_banner_imageView.loadProfileImageWithUrl(url: url, completion: {
                    if $0 == true {
                        if let image = self.profile_banner_imageView.image , let id = follower.banner_picture_id {
                            ImageStore.shared.setImage(image, forKey: id) // set net ........
                            helper.clickableBannerImageView = image

                        }
                    }
                })
            }
            else {
                helper.clickableBannerImageView = #imageLiteral(resourceName: "placeholder_image")
            }
            if let url = follower.profile_picture_URL {
                profile_picture_imageView.loadProfileImageWithUrl(url: url, completion: {
                    if $0 == true {
                        if let image = self.profile_picture_imageView.image , let id = follower.profile_picture_id {
                            ImageStore.shared.setImage(image, forKey: id) // set net ........
                            helper.clickableProfileImageView = image
                        }
                    }
                    
                })
            }
            else {
                helper.clickableBannerImageView = #imageLiteral(resourceName: "placeholder_image")
            }
        }
        else {
           
            if let id = follower.banner_picture_id, let image = ImageStore.shared.image(forKey: id) {
                DispatchQueue.main.async {
                    self.profile_banner_imageView.image = image
                    helper.clickableBannerImageView = image
                }
            }
            
            if let id = follower.profile_picture_id, let image = ImageStore.shared.image(forKey: id) {
                DispatchQueue.main.async {
                    self.profile_picture_imageView.image = image
                    helper.clickableProfileImageView = image
                }
            }
        }
    
        userNameLabel.text = follower.userName
        handleLabel.text = "@\(follower.handle)"
    }

}
