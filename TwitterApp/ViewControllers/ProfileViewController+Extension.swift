//
//  ProfileViewController+Extension.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/5/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tweets[indexPath.item].text
        let approximateWidthForTweetText = view.frame.width - 50 - 44
        
        let estimatedHeight = helper.estimateFrameForText(text: text, size: approximateWidthForTweetText).height + 10
        
        return CGSize(width: view.frame.width, height: estimatedHeight + 40)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
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
}
