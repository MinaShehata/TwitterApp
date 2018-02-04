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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profile_picture_URL.image = nil
        usernameLabel.text = nil
        HandleLabel.text = nil
        BioTextView.text = nil
        
    }

    func setupCell(with follower: Follower) {
        let userNameAttributedText = NSAttributedString(string: follower.userName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        usernameLabel.attributedText = userNameAttributedText
        // setup handle
        let usernameString = "@\(follower.handle)"
        let handleAttributedText = NSAttributedString(string: usernameString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        HandleLabel.attributedText = handleAttributedText
        
        // setup textView........
        let attributedBio = NSMutableAttributedString(string: follower.bio, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
        BioTextView.attributedText = attributedBio
        
        // setup Image
        guard let url = URL(string: follower.profile_picture_URL) else { return }
        profile_picture_URL.loadProfileImageWithUrl(url: url)
    }
    
}
