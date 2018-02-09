//
//  StoreFollower.swift
//  TwitterApp
//
//  Created by Mina Gad on 2/7/18.
//  Copyright © 2018 Mina Gad. All rights reserved.
//

import Foundation

final class FollowerStore {
    
    // singleton object......... that manage all operation of database  in system......
    static let shared = FollowerStore()
    private init() {
        // get all followers from document dirctory in application Sandbox
        if let archivedFollowers = NSKeyedUnarchiver.unarchiveObject(withFile: followersArchiveURL.path) as? [Follower] {
            followers = archivedFollowers
        }
    }
    /////
    
    // refrence
    var followers = [Follower]()
    // path on mobile
    let followersArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("followers.archive")
    }()
    
    // helper Function......
    func append(with followers: [Follower]) {
        self.followers += followers
    }
    
    func getTweets(of follower: Follower) -> [Tweet]? {
        return follower.tweets
    }
    
    func setTweets(of follower: Follower, with tweets: [Tweet]) {
        follower.tweets = tweets
    }
    
    // save to disk.......
    func save() -> Bool {
        print("followers path url \(followersArchiveURL)")
        return NSKeyedArchiver.archiveRootObject(followers, toFile: followersArchiveURL.path)
    }
    
    func updateDatabase() -> Bool {
        do{
            let exist = FileManager.default.fileExists(atPath: followersArchiveURL.path)
            if exist {
                try FileManager.default.removeItem(atPath: followersArchiveURL.path)
            }
            let x = save()
            x ? print("saved updates successfully") : print("error in updating database \(followersArchiveURL.path)")
            return true
        }
        catch {
            print("error in updating database \(error.localizedDescription)")
        }
        return false
    }
    
}
