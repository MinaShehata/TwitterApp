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
            let text = tweets[indexPath.item].text
            let approximateWidthForTweetText = view.frame.width - 50 - 44
            
            let estimatedHeight = helper.estimateFrameForText(text: text, size: approximateWidthForTweetText).height + 10
            return CGSize(width: view.frame.width, height: estimatedHeight + 40)
        }
        return CGSize.zero
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
            return header
            }
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
}






