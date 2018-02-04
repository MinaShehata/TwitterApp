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
    
    // instantiate refresh control just when user refresh
    lazy var refreshControll: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getAllFollowers), for: .valueChanged)
        return refresher
    }()
    
    var followers: [Follower] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setupCollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.FollowerCell, bundle: nil), forCellWithReuseIdentifier: Constants.FollowerCell)
        collectionView.refreshControl = refreshControll
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        setupNavigationBarButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getAllFollowers()
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // these Button just for enhance twitter UI Navigation Bar
    private func setupNavigationBarButtons(){
        
        let twitterTitle = UIBarButtonItem(title: "Followers", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = twitterTitle
        
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
    
    // added @objc because of #selector is Objective-c Function
    @objc private func getAllFollowers() {
        guard let user = helper.getCredential() else { return }
        let parameter = "screen_name=\(user.userName)"
        guard let url = URL(string: "\(Constants.followers)?\(parameter)") else { return }
        API.shared.getFollowers(url: url, bearer: user.bearer_token) { (followers) in
            if let followers = followers {
                self.refreshControll.endRefreshing()
                self.followers = followers
                self.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == Constants.follower_profile_data {
            if let vc = segue.destination as? ProfileViewController {
                vc.follower = sender as? Follower
            }
        }
    }
    
}

extension FollowerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let follower = followers[indexPath.item]
        let aproximateWidthOfBioTextView = view.frame.width - 16 - 40 - 5 - 16 - 5
        
        // if has bio or not
        let size = CGSize(width: aproximateWidthOfBioTextView, height: 1000)
       
        let attribute = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)]
       
        if let bio = follower.bio, follower.bio != "" {
            let estimatedFrame = NSString(string: bio).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 17 + 42)
        }

        return CGSize(width: view.frame.width, height: 59)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFollower = followers[indexPath.item]
        performSegue(withIdentifier: Constants.follower_profile_data, sender: selectedFollower)
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
