//
//  FollowerVC.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/4/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import UIKit

class FollowerViewController: BaseVC {

    @IBOutlet weak var collectionView: UICollectionView!

    
    // lazy means instantiate refresh control just when user refresh
    final lazy var refreshControll: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getAllFollowers), for: .valueChanged)
        refresher.tintColor = UIColor.blue
        return refresher
    }()
    
    var followers = [Follower]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // setupCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.FollowerCell, bundle: nil), forCellWithReuseIdentifier: Constants.FollowerCell)
        collectionView.refreshControl = refreshControll
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        setupNavigationBarButtons()

        // if connected load data from network else load from offline store
        helper.connected ? getAllFollowers() : loadOfflineData()
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // these Button just for enhance twitter UI Navigation Bar
    final private func setupNavigationBarButtons(){
        let signout = NSLocalizedString("SignOut", comment: "sign out button Name")
        let signOutButton = UIBarButtonItem(title: signout, style: .plain, target: self, action: #selector(SignOutUser))
        signOutButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        navigationItem.leftBarButtonItem = signOutButton
        
        let composeTweet = UIBarButtonItem(image: #imageLiteral(resourceName: "Compose Tweet"), style: .plain, target: nil, action: nil)
        composeTweet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
         let searchTweet = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: nil, action: nil)
        searchTweet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationItem.rightBarButtonItems = [composeTweet, searchTweet]
        //
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Tweeter logo"))
        imageView.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    var next_cursor: Int64 = -1 // because my device is 32-bit procossor and cursor is long value ....
    var isLoading = false
    // added @objc because of #selector is Objective-c Function
    @objc final private func getAllFollowers() {
        
        guard !isLoading else { return }
        isLoading = true // close loading
        
        API.shared.followers(completion: { [weak self] (followers, next_cursor, error)  in
            self?.isLoading = false // open loading again ..
            if let error = error {
                self?.showAlert(title: "error", message: error.localizedDescription)
                return
            }
            self?.refreshControll.endRefreshing()
            if let followers = followers {
                self?.followers = followers
                FollowerStore.shared.newFollowers = followers
                self?.collectionView.reloadData()
                self?.next_cursor = next_cursor
                
            }
        })
    }
    // load data from data base if network offline.........
    func loadOfflineData() {
        refreshControll.endRefreshing()
        followers = FollowerStore.shared.savedFollowers
        collectionView.reloadData()
    }
    
    // load on scrolling.....
    func load_more() { //load  another 10 users....
        guard !isLoading else { return }
        guard next_cursor > 0 else { return }
        isLoading = true // cloase loading
        API.shared.followers(cursor: next_cursor) { [weak self](followers, next_cursor, error) in
            self?.isLoading = false // open loading more

            if let error = error {
                self?.showAlert(title: "error", message: error.localizedDescription)
                return
            }
            if let followers = followers {
                self?.followers.append(contentsOf: followers)
                self?.collectionView.reloadData()
                self?.next_cursor = next_cursor
            }
        }
    }
    
    // restart if layout change......
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

