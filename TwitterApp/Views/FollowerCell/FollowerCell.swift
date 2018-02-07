//
//  FollowerCell.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {

    @IBOutlet weak var profile_picture_URL: customImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var HandleLabel: UILabel!
    @IBOutlet weak var BioTextView: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile_picture_URL.image = nil
        usernameLabel.text = nil
        HandleLabel.text = nil
        BioTextView.text = nil
    }
    
    func setupCell(with follower: Follower, connected: Bool) {
        let userNameAttributedText = NSAttributedString(string: follower.userName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        usernameLabel.attributedText = userNameAttributedText
        // setup handle
        let usernameString = "@\(follower.handle)"
        let handleAttributedText = NSAttributedString(string: usernameString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        HandleLabel.attributedText = handleAttributedText
        
        // setup textView........
        if let bio = follower.bio {
            let attributedBio = NSMutableAttributedString(string: bio, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
            BioTextView.attributedText = attributedBio
        }

        // setup Image
        guard let profilePicURL = follower.profile_picture_URL else {
            return
        }
        
        let imageStore = ImageStore()
        if connected {
            profile_picture_URL.loadProfileImageWithUrl(url: profilePicURL, completion: nil)
            if let image = profile_picture_URL.image , let id = follower.profile_picture_id {
                imageStore.deleteImage(forKey: id)
                imageStore.setImage(image, forKey: id)
                print("\n saved \n")
            }
        }
        else {
            if let id = follower.profile_picture_id, let image = imageStore.image(forKey: id) {
                    profile_picture_URL.image = image
            }
        }
        
    }
}
