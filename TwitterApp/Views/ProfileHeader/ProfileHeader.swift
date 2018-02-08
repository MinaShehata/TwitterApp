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
           
            if let url = follower.profile_banner_url {
                profile_banner_imageView.loadProfileImageWithUrl(url: url, completion: {
                    if $0 {
                        let imageStore = ImageStore()
                        if let image = self.profile_banner_imageView.image , let id = follower.banner_picture_id {
                            imageStore.setImage(image, forKey: id) // set net ........
                        }
                    }
                    else{
                        let imageStore = ImageStore()
                        if let id = follower.banner_picture_id {
                            if let image = imageStore.image(forKey: id) {
                                DispatchQueue.main.async {
                                    self.profile_banner_imageView.image = image
                                }
                                
                            }
                        }
                    }
                    
                })
            }

            if let url = follower.profile_picture_URL {
                profile_picture_imageView.loadProfileImageWithUrl(url: url, completion: {
                    if $0 {
                        let imageStore = ImageStore()
                        if let image = self.profile_picture_imageView.image , let id = follower.profile_picture_id {
                            imageStore.setImage(image, forKey: id) // set net ........
                        }
                    }
                    else{
                        let imageStore = ImageStore()
                        if let id = follower.profile_picture_id {
                            if let image = imageStore.image(forKey: id) {
                                DispatchQueue.main.async {
                                    self.profile_picture_imageView.image = image
                                }
                            }
                        }
                    }
                })
            }
        userNameLabel.text = follower.userName
        handleLabel.text = "@\(follower.handle)"
    }

}









