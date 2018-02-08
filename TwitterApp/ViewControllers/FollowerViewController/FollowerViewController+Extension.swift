//
//  FollowerViewControllerModeDelegate.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/6/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

protocol FollowerViewControllerModeDelegate: class {
    func did(update productSort: Follower) -> CGSize
}

extension FollowerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func compare(_ width: CGFloat, and height: CGFloat) -> Bool {
        
        if width < height {
//            in portrait
            return true
        }
        else { return false } // in landscape
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let follower = followers[indexPath.item]
        let aproximateWidthOfBioTextView = view.frame.width - 16 - 40 - 5 - 16 - 10
        
        // if has bio or not
        if let bio = follower.bio, follower.bio != "" {
            let estimatedFrame = helper.estimateFrameForText(text: bio, size: aproximateWidthOfBioTextView)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 17 + 42)
            
        }
        
        return CGSize(width: view.frame.width, height: 59)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedFollower = followers[indexPath.item]
        performSegue(withIdentifier: Constants.follower_profile_data, sender: selectedFollower)
    }
    
    
    
    
    
    /// pagination load more.......
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let followers_count = followers.count
        if indexPath.item == followers_count - 1 {
            load_more()
        }
    }
    
    
    
}

extension FollowerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FollowerCell, for: indexPath) as? FollowerCell {
            let follower = followers[indexPath.item]
            cell.setupCell(with: follower)
            return cell
        }
        return UICollectionViewCell()
    }
}
