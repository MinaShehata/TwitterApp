//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit


import UIKit

class ProfileViewController: UIViewController {
    
    var follower: Follower?
    var tweets = [Tweet]()
    
    // tweets collection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Setup.....
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.ProfileHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.ProfileHeader)
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLastTenTweets()
    }
    
    private func getLastTenTweets() {
        guard let user = helper.getCredential(), let follower = follower else { return }
        let parameter = "q=@\(follower.handle)&count=10" // last 10 tweets
        guard let url = URL(string: "\(Constants.tweets)?\(parameter)") else { return }
        API.shared.getFollowerLastTenTweets(follower: follower, url: url, bearer: user.bearer_token) { [weak self](tweets) in
            if let tweets = tweets {
                self?.tweets = tweets
                self?.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true) // pop or back to followers vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
