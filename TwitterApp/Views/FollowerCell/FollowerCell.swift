//
//  FollowerCell.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {

    @IBOutlet weak var profile_picture_URL: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(with follower: Follower) {
        profile_picture_URL.image = #imageLiteral(resourceName: "Mina2017")
        nameLabel.text = follower.userName
        handleLabel.text = follower.handle
        bioTextView.text = follower.bio
    }
    
}
