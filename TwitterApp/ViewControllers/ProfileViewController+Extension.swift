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
        let text = tweets[indexPath.item].text
        let approximateWidthForTweetText = view.frame.width - 50 - 44

        let estimatedHeight = helper.estimateFrameForText(text: text, size: approximateWidthForTweetText).height + 10

        return CGSize(width: view.frame.width, height: estimatedHeight + 40)
    }
}
// MARK:- DATASOURCE
extension ProfileViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.TweetCell, for: indexPath) as? TweetCell {
            let tweet = tweets[indexPath.item]
            cell.setupTweet(with: tweet)
            return cell
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
        guard let follower = follower, let bio = follower.bio, bio != "" else {
            return CGSize(width: view.frame.width, height: (view.frame.height / 2))
        }
        let approximateWidthForBioText = view.frame.width - 50
        let estimateHeight = helper.estimateFrameForText(text: bio, size: approximateWidthForBioText).height + 20
        return CGSize(width: view.frame.width, height: estimateHeight + 320)
    }
    
}






