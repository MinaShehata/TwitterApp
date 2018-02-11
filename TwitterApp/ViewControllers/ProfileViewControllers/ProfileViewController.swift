//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//


import UIKit

class ProfileViewController: BaseVC {
    
    var follower: Follower?
    
    // tweets collection View
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileLayout: ProfileLayout!
    // clickable stuff.........
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clickableImageView: UIImageView! {
        didSet {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeScrollView))
            swipeGesture.direction = .up
            clickableImageView.addGestureRecognizer(swipeGesture)
        }
    }
    @objc private func closeScrollView() {
        setupAnimation()
    }
    private func setupAnimation() {
        scrollView.zoomScale = 1.0

        UIView.animate(withDuration: 0.5, animations: {
            self.clickableImageView.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height / 2))
            self.scrollView.alpha = 0
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Setup.....
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.ProfileHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.ProfileHeader)
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
        profileLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 200)
        // scrollViewSetup ...
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        //        get data from network
        helper.connected ? getLastTenTweets() : loadOflineStorage()
        
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

    // this outlet of button just for localization........
    @IBOutlet weak var backButtonImage: UIButtonX! {
        didSet {
            let imageButton = Language.currentLanguage() == "ar" ? #imageLiteral(resourceName: "BackButtonForArabic") : #imageLiteral(resourceName: "BackButton")
            backButtonImage.setImage(imageButton, for: .normal)
        }
    }
    
    @IBAction func backButton(_ sender: UIButtonX)
    {
        // set here for localization Direction.......
        
        self.navigationController?.popViewController(animated: true) // pop or back to followers vc
    }
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return clickableImageView
    }
}
