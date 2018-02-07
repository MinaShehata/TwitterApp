//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/6/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionReusableView {

    @IBOutlet var imageLoadingIndicator: [UIActivityIndicatorView]!
    @IBOutlet weak var profile_banner_imageView: customImageView!
    @IBOutlet weak var profile_picture_imageView: customImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
//    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var followingButton: UIButtonX! {
        didSet {
            followingButton.setImage(#imageLiteral(resourceName: "FollowerCheckButton"), for: .normal)
            followingButton.imageView?.contentMode = .scaleAspectFit
            followingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }
    
    func setupHeader(with follower: Follower, connected: Bool) {
        if connected {
            for loader in imageLoadingIndicator {
                loader.startAnimating()
            }
            if let url = follower.profile_banner_url {
                profile_banner_imageView.loadProfileImageWithUrl(url: url, completion: { [weak self] grant in
                    if grant {
                        self?.imageLoadingIndicator[0].stopAnimating()
                        self?.imageLoadingIndicator[0].hidesWhenStopped = true
                        let imageStore = ImageStore()
                        if let image = self?.profile_banner_imageView.image , let id = follower.banner_picture_id {
                            imageStore.deleteImage(forKey: id) // delete old ......
                            imageStore.setImage(image, forKey: id) // set net ........
                            print("\n saved \n")
                        }
                    }
                })
            }
            else {
                imageLoadingIndicator[0].stopAnimating()
                imageLoadingIndicator[0].hidesWhenStopped = true
            }
            if let url = follower.profile_picture_URL {
                profile_picture_imageView.loadProfileImageWithUrl(url: url, completion: { [weak self] grant in
                    if grant {
                        self?.imageLoadingIndicator[1].stopAnimating()
                        self?.imageLoadingIndicator[1].hidesWhenStopped = true
                        let imageStore = ImageStore()
                        if let image = self?.profile_picture_imageView.image , let id = follower.profile_picture_id {
                            imageStore.deleteImage(forKey: id)
                            imageStore.setImage(image, forKey: id)
                            print("\n saved \n")
                        }
                    }
                })
            }
            else {
                imageLoadingIndicator[1].stopAnimating()
                imageLoadingIndicator[1].hidesWhenStopped = true
            }
        }
        else {
            let imageStore = ImageStore()
            if let id = follower.banner_picture_id {
                if let image = imageStore.image(forKey: id) {
                    profile_banner_imageView.image = image
                }
            }
            if let id = follower.profile_picture_id {
                if let image = imageStore.image(forKey: id) {
                    profile_picture_imageView.image = image
                }
            }
            imageLoadingIndicator[0].hidesWhenStopped = true
            imageLoadingIndicator[1].hidesWhenStopped = true
        }
    
        userNameLabel.text = follower.userName
        handleLabel.text = "@\(follower.handle)"
    }

}









