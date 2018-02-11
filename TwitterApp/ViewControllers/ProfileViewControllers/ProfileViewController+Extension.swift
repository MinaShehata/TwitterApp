//
//  ProfileViewController+Extension.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

// delegate
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let follower = follower, let tweets = follower.tweets {
            if let text = tweets[indexPath.item].text {
            let approximateWidthForTweetText = view.frame.width - 73
            
            let estimatedHeight = helper.estimateFrameForText(text: text, size: approximateWidthForTweetText).height + 20
            return CGSize(width: view.frame.width, height: estimatedHeight + 52)
            }
        }
        return CGSize(width: view.frame.width, height: 52)
        
    }
    // grid setup here
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
// MARK:- DATASOURCE
extension ProfileViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let follower = follower , let tweets = follower.tweets {
            return tweets.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.TweetCell, for: indexPath) as? TweetCell {
            if let follower = follower, let tweets = follower.tweets {
                let tweet = tweets[indexPath.item]
                cell.setupTweet(with: tweet)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ProfileHeader, for: indexPath) as? ProfileHeader,let follower = follower {
                header.setupHeader(with: follower)
                setupClickableBannerInHeaderView(image: header.profile_banner_imageView)
                setupClickableProfileInHeaderView(image: header.profile_picture_imageView)
            return header
            }
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    private func setupClickableBannerInHeaderView(image: customImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openBannerImage))
        tapGesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapGesture)
    }
    
    
    private func setupClickableProfileInHeaderView(image: customImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfileImage))
        tapGesture.numberOfTapsRequired = 1
        image.addGestureRecognizer(tapGesture)
    }
    @objc func openBannerImage() {
        clickableImageViewAnimation()
        clickableImageView.image = helper.clickableBannerImageView
    }
    @objc func openProfileImage() {
        clickableImageViewAnimation()
        clickableImageView.image = helper.clickableProfileImageView
    }
    
    func clickableImageViewAnimation() {
        clickableImageView.transform = CGAffineTransform(translationX: 0, y: (-view.frame.height / 2))
        UIView.animate(withDuration: 0.5, animations: {
            self.scrollView.alpha = 1
            self.clickableImageView.transform = .identity
        })
    }
    
}






