//
//  TweetCell.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class TweetCell: UICollectionViewCell {

    @IBOutlet weak var profile_picture_imageView: customImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var created_atLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile_picture_imageView.image = nil
        tweetTextView.text = nil
        usernameLabel.text = nil
        handleLabel.text = nil
        created_atLabel.text = nil
    }
    
    func setupTweet(with tweet: Tweet)
    {
        if helper.connected {
            if let followerProfilePicture = tweet.follower?.profile_picture_URL {
                profile_picture_imageView.loadProfileImageWithUrl(url: followerProfilePicture, completion: {
                    if $0 == true {
                        if let image = self.profile_picture_imageView.image, let id = tweet.follower?.profile_picture_id {
                            ImageStore.shared.setImage(image, forKey: id) // set new ........
                        }
                    }
                })
                
            }
        }
        else {
            if let id = tweet.follower?.profile_picture_id, let image = ImageStore.shared.image(forKey: id) {
                DispatchQueue.main.async {
                    self.profile_picture_imageView.image = image
                }
            }
        }


        
        let textViewAttributed = NSAttributedString(string: tweet.text, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        tweetTextView.attributedText = textViewAttributed
        guard let follower = tweet.follower else { return }
        let usernameText = NSAttributedString(string: follower.userName, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        usernameLabel.attributedText = usernameText
        
        let handleText = NSAttributedString(string: "@\(follower.handle)", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        handleLabel.attributedText = handleText
        
        let created_atText = NSAttributedString(string: "\(tweet.created_at)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        created_atLabel.attributedText = created_atText
    }
}
