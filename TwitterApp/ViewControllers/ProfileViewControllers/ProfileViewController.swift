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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Setup.....
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.ProfileHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.ProfileHeader)
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
        
        profileLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
        helper.connected ? getLastTenTweets() : loadOflineStorage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // start network observer for lestin to network state.........
        helper.addNetworkObserver(on: self)
       
    }
  
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        helper.removeNetworkObserver(from: self)
    }
    
    private func getLastTenTweets() {
        if let follower = follower {
            API.shared.tweets(of: follower) { [weak self] (tweets, error) in
                if let error = error {
                    self?.showAlert(title: "error", message: error.localizedDescription)
                    return
                }
                if let tweets = tweets {
                    follower.tweets = tweets
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    func loadOflineStorage() {
        if let follower = follower {
            follower.tweets = FollowerStore.shared.getTweets(of: follower)
            collectionView.reloadData()
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
