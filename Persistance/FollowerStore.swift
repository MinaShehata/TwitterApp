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
            savedFollowers = archivedFollowers
        }
    }
    /////
    
    // refrence old Followers
    var savedFollowers = [Follower]()
    
    // refrence new followers if connected to internet
    var newFollowers = [Follower]()
    
    // path on mobile sand box
    let followersArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("followers.archive")
    }()
    
    // helper Function......
    func append(with followers: [Follower]) {
        self.newFollowers += followers
    }
    
    func getTweets(of follower: Follower) -> [Tweet]? {
        return follower.tweets
    }
    
    func setTweets(of follower: Follower, with tweets: [Tweet]) {
        follower.tweets = tweets
    }
    
    // save to disk.......
    func save() -> Bool {
//        print("followers path url \(followersArchiveURL)")
        return NSKeyedArchiver.archiveRootObject(newFollowers, toFile: followersArchiveURL.path)
    }
    
    func updateDatabase() -> Bool {
        do{
            // remove old followers from mobile memory and update database...... with new followers
            let exist = FileManager.default.fileExists(atPath: followersArchiveURL.path)
            if exist {
                try FileManager.default.removeItem(atPath: followersArchiveURL.path)
            }
            if !newFollowers.isEmpty {
                let x = save()
                x ? print("saved updates successfully") : print("error in updating database \(followersArchiveURL.path)")
                return true
            }
        }
        catch {
            print("error in updating database \(error.localizedDescription)")
        }
        return false
    }
    
}
