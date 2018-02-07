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
        NetworkAvailability.startNotifier()
        // CollectionView Setup.....
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.ProfileHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.ProfileHeader)
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
        
        profileLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
//        profileLayout.sectionInset = UIEdgeInsets(top: -20, left: 1, bottom: 1, right: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        getLastTenTweets()
    }
    
    func connected() -> Bool{
        return NetworkAvailability.checkNetworkConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NetworkAvailability.stopNotifier() // stop the notifier..........
    }
    
    private func getLastTenTweets() {
        if let follower = follower{
            if connected() {
                API.shared.tweets(of: follower) {
                    if let tweets = $0 {
                        follower.tweets = tweets
                        self.collectionView.reloadData()
                    }
                }
            }
            else {
                follower.tweets = followerStore.getTweets(of: follower)
                collectionView.reloadData()
            }
        }
        
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
