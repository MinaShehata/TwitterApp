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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var follower: Follower?
    
    // tweets collection View
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileLayout: ProfileLayout!
    
    // for persistance.....
    var followerStore = FollowerStore()

    /////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CollectionView Setup.....
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.ProfileHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.ProfileHeader)
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
        
        profileLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
        getLastTenTweets()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
  
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func getLastTenTweets() {
        if let follower = follower{
            API.shared.tweets(of: follower) { [weak self] (tweets, error) in
                if error != nil {
                    self?.loadOflineStorage(with: follower)
                    return
                }
                if let tweets = tweets {
                    follower.tweets = tweets
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    func loadOflineStorage(with follower: Follower){
        follower.tweets = followerStore.getTweets(of: follower)
        collectionView.reloadData()
    }

    @IBAction func backButton(_ sender: UIButtonX)
    {
        self.navigationController?.popViewController(animated: true) // pop or back to followers vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
