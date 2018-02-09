//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/6/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileHeader: UICollectionReusableView {

    @IBOutlet weak var profile_banner_imageView: customImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImageInFullBrowser))
            tapGesture.numberOfTapsRequired = 1
            helper.image = "banner"
            profile_banner_imageView.addGestureRecognizer(tapGesture)
        }
    }
    // for show in full browser
    let blackView = UIScrollView()
    lazy var showBannerImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openImageInFullBrowser))
        tapGesture.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tapGesture)
        iv.image = #imageLiteral(resourceName: "placeholder_image")
        return iv
    }()
    
    lazy var showProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfileImageInFullProwser))
        tapGesture.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tapGesture)
        iv.image = #imageLiteral(resourceName: "placeholder_image")
        return iv
    }()
    
    @IBOutlet weak var profile_picture_imageView: customImageView!{
        didSet{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfileImageInFullProwser))
            tapGesture.numberOfTapsRequired = 1
            helper.image = "profile"
            profile_picture_imageView.addGestureRecognizer(tapGesture)
        }
    }
    
    
    
    
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
                profile_banner_imageView.loadProfileImageWithUrl(url: url)
                
                if let image = self.profile_banner_imageView.image , let id = follower.banner_picture_id {
                    ImageStore.shared.setImage(image, forKey: id) // set net ........
                }
            }
            
            
            if let url = follower.profile_picture_URL {
                profile_picture_imageView.loadProfileImageWithUrl(url: url)
                if let image = self.profile_picture_imageView.image , let id = follower.profile_picture_id {
                    ImageStore.shared.setImage(image, forKey: id) // set net ........
                }
            }
            
        }
        else {
           
            if let id = follower.banner_picture_id, let image = ImageStore.shared.image(forKey: id) {
                DispatchQueue.main.async {
                    self.profile_banner_imageView.image = image
                }
            }
            
            if let id = follower.profile_picture_id, let image = ImageStore.shared.image(forKey: id) {
                DispatchQueue.main.async {
                    self.profile_picture_imageView.image = image
                }
            }
        }
            
            
    
        userNameLabel.text = follower.userName
        handleLabel.text = "@\(follower.handle)"
    }

}




extension ProfileHeader: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return helper.image == "banner" ? profile_banner_imageView : profile_picture_imageView
    }

    
    @objc func openImageInFullBrowser() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let value = helper.inZooming
        if value == false {
            helper.inZooming = true
            showBannerImageView.removeFromSuperview()
            blackView.removeFromSuperview()
        }
        if value {
            blackView.backgroundColor = .black
            blackView.minimumZoomScale = 1.0
            blackView.maximumZoomScale = 6.0
            blackView.delegate = self
            blackView.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(blackView)
            blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            blackView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
            blackView.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            showBannerImageView.translatesAutoresizingMaskIntoConstraints = false
            showBannerImageView.contentMode = .scaleAspectFit
            blackView.addSubview(showBannerImageView)
            
            showBannerImageView.topAnchor.constraint(equalTo: blackView.topAnchor).isActive = true
            showBannerImageView.leftAnchor.constraint(equalTo: blackView.leftAnchor).isActive = true
            showBannerImageView.rightAnchor.constraint(equalTo: blackView.rightAnchor).isActive = true
            showBannerImageView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor).isActive = true
            showBannerImageView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
            showBannerImageView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor).isActive = true
            showBannerImageView.image = profile_banner_imageView.image
            helper.inZooming = false
        }
    }
    @objc func openProfileImageInFullProwser() {

        guard let window = UIApplication.shared.keyWindow else { return }
        let value = helper.inZooming
        if value == false {
            helper.inZooming = true
            showProfileImageView.removeFromSuperview()
            blackView.removeFromSuperview()
        }
        if value {
            blackView.backgroundColor = .black
            blackView.minimumZoomScale = 1.0
            blackView.maximumZoomScale = 6.0
            blackView.delegate = self
            blackView.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(blackView)
            blackView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            blackView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
            blackView.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
            blackView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            showProfileImageView.translatesAutoresizingMaskIntoConstraints = false
            showProfileImageView.contentMode = .scaleAspectFit
            blackView.addSubview(showProfileImageView)
            
            showProfileImageView.topAnchor.constraint(equalTo: blackView.topAnchor).isActive = true
            showProfileImageView.leftAnchor.constraint(equalTo: blackView.leftAnchor).isActive = true
            showProfileImageView.rightAnchor.constraint(equalTo: blackView.rightAnchor).isActive = true
            showProfileImageView.bottomAnchor.constraint(equalTo: blackView.bottomAnchor).isActive = true
            showProfileImageView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor).isActive = true
            showProfileImageView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor).isActive = true
            showProfileImageView.image = profile_picture_imageView.image
            helper.inZooming = false

        }
        
        
    }
}





