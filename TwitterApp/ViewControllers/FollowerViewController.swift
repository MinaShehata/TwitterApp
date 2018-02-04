//
//  FollowerVC.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var followers: [Follower] = []
    
    let mina = Follower(userName: "Mina Shehata", handle: "@minashehata5", bio: "skjdfbsdfkbsdf fdmsbfkjbsdkjfs dfsdfbndsjkfbsdkjfbdsfsd ......", profile_picture_URL: "")
    
    let mina2 = Follower(userName: "Mina Shehata", handle: "@minashehata5", bio: "My name is Mina Shehata Gad ,I 'm senior iOS Developer, Love iOS Programminga Gad ,I 'm senior iOS Developer, Love iOS Programming a Gad ,I 'm senior iOS Developer, Love iOS Programming a Gad ,I 'm senior iOS Developer, Love iOS Programming", profile_picture_URL: "")
    
    let mina3 = Follower(userName: "Mina Shehata", handle: "@minashehata5", bio: "My name is Mina Shehata Gad ", profile_picture_URL: "")
    let mina4 = Follower(userName: "Mina Shehata", handle: "@minashehata5", bio: "My name is Mina Shehata Gad ,I 'm My name is Mina Shehata Gad ,I 'm senior iOS Developer, Love iOS Programming", profile_picture_URL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(red: 232/255, green: 236/255, blue: 241/255, alpha: 1)
        
        followers = [mina, mina2, mina3, mina4]
        
        // setupCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.FollowerCell, bundle: nil), forCellWithReuseIdentifier: Constants.FollowerCell)
    }
    
    
}

extension FollowerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let follower = followers[indexPath.item]
        let aproximateWidthOfBioTextView = view.frame.width - 16 - 50 - 5 - 16 - 10
        
        let size = CGSize(width: aproximateWidthOfBioTextView, height: 1000)
        
        let attribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)]
        
        
        let estimatedFrame = NSString(string: follower.bio).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        return CGSize(width: view.frame.width, height: estimatedFrame.height + 10 + 5 + 60)
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
