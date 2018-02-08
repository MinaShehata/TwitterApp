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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // refreence for persistance
    //////////////
    // lazy means instantiate refresh control just when user refresh
    final lazy var refreshControll: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getAllFollowers), for: .valueChanged)
        refresher.tintColor = UIColor.blue
        return refresher
    }()
    var followerStore = FollowerStore()
    
    var followers = [Follower]()
    override func viewDidLoad() {
        super.viewDidLoad()
       // start network notifier............
        let _ = NetworkAvailability.checkNetworkConnection()
        ///////////////////////////
        // setupCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.FollowerCell, bundle: nil), forCellWithReuseIdentifier: Constants.FollowerCell)
        collectionView.refreshControl = refreshControll
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        setupNavigationBarButtons()
        
        
    }

    func connected() -> Bool{
        return NetworkAvailability.checkNetworkConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getAllFollowers()

    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NetworkAvailability.stopNotifier()
    }
    
    // these Button just for enhance twitter UI Navigation Bar
    final private func setupNavigationBarButtons(){
        
        let signOutButton = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(SignOutUser))
        
        navigationItem.leftBarButtonItem = signOutButton
        
        let composeTweet = UIBarButtonItem(image: #imageLiteral(resourceName: "Compose Tweet"), style: .plain, target: nil, action: nil)
         let searchTweet = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [composeTweet, searchTweet]
        //
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Tweeter logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 40, height: 28)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 28))
        view.addSubview(imageView)
        navigationItem.titleView = view
    }
    
    @objc private func SignOutUser() {
        helper.removeCredential()
    }
    
    // pagination 10 per page // some variables
    var current_cursor = -1
    var next_cursor = 1
    
    // added @objc because of #selector is Objective-c Function
    
    @objc final private func getAllFollowers() {
        if connected() {
            next_cursor = -1
            self.refreshControll.endRefreshing()
            API.shared.followers(completion: { (followers, next_cursor) in
                if let followers = followers {
                    self.followers = followers
                    self.collectionView.reloadData()
                    self.next_cursor = next_cursor
                }
            })
        }
        else {
            self.refreshControll.endRefreshing()
            followers = followerStore.followers
            collectionView.reloadData()
        }
    }
    
    // load on scrolling.....
    func load_more() { //load  another 10 users....
        API.shared.followers(current_cursor: next_cursor) { (followers, next_cursor) in
            if let followers = followers {
                self.followers.append(contentsOf: followers)
                self.collectionView.reloadData()
                self.next_cursor = next_cursor
            }
        }
    }
    
    
    // grid setup here
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.follower_profile_data {
            if let vc = segue.destination as? ProfileViewController
            {
                vc.follower = sender as? Follower                
            }
        }
    }

}

