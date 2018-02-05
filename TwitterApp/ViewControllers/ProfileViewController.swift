//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var follower: Follower?
    var tweets = [Tweet]()
    // some Outlets for View
    @IBOutlet weak var profile_banner_imageView: customImageView!
    @IBOutlet weak var profile_picture_imageView: customImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    // tweets table View
    @IBOutlet weak var collectionView: UICollectionView!
    
    // container view contain name, handle, and bio
    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var followingButton: UIButtonX! {
        didSet {
            
            followingButton.setImage(#imageLiteral(resourceName: "FollowerCheckButton"), for: .normal)
            followingButton.imageView?.contentMode = .scaleAspectFit
            followingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewSetup
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.TweetCell, bundle: nil), forCellWithReuseIdentifier: Constants.TweetCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        getLastTenTweets()
    }
    
    private func getLastTenTweets() {
        guard let user = helper.getCredential(), let follower = follower else { return }
        let parameter = "q=@\(follower.handle)&count=10" // last 10 tweets
        guard let url = URL(string: "\(Constants.tweets)?\(parameter)") else { return }
        API.shared.getFollowerLastTenTweets(follower: follower, url: url, bearer: user.bearer_token) { (tweets) in
            if let tweets = tweets {
                self.tweets = tweets
                self.collectionView.reloadData()
            }
        }
    }
    
    
    private func setupUI() {
        if let follower = follower {
            if let profile_banner_url = follower.profile_banner_url, let followerBannerURL = URL(string: profile_banner_url){
                profile_banner_imageView.loadProfileImageWithUrl(url: followerBannerURL)
            }
            if let rofile_picture_URL = follower.profile_picture_URL, let followerProfilePictureURL = URL(string: rofile_picture_URL) {
                profile_picture_imageView.loadProfileImageWithUrl(url: followerProfilePictureURL)
            }
            userNameLabel.text = follower.userName
            handleLabel.text = "@\(follower.handle)"
            setupBioTextView(with: follower.bio)
        }
    }
    var bioTextView: UITextView!
    private func setupBioTextView(with bio: String?) {
        //setup text View constraint manualy manualy
        // property initialization......
        bioTextView = {
            let tv = UITextView()
            tv.isScrollEnabled = false
            tv.isEditable = false
            tv.isSelectable = false
            tv.backgroundColor = .clear
            tv.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            tv.text = bio
            tv.clipsToBounds = true
            tv.translatesAutoresizingMaskIntoConstraints = false
            return tv
        }()
        containterView.addSubview(bioTextView)
        
        bioTextView.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 0).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: containterView.leftAnchor, constant: 20).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: containterView.rightAnchor, constant: -20).isActive = true

        // setup width and height of textView
        if let bio = bio, bio != "" {
            let approximateWidthForBio = containterView.frame.width - 40
            let estimatedFrame = helper.estimateFrameForText(text: bio, size: approximateWidthForBio)
            let boundsOfTextView = CGSize(width: approximateWidthForBio, height: estimatedFrame.height + 30)
            bioTextView.heightAnchor.constraint(equalToConstant: boundsOfTextView.height).isActive = true
        }
        else
        {
            bioTextView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            bioTextView.removeFromSuperview()
        }
        //
        setupTableViewAnchor()
    }
    private func setupTableViewAnchor() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 5).isActive = true
        collectionView.leftAnchor.constraint(equalTo: containterView.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containterView.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: containterView.rightAnchor).isActive = true
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

