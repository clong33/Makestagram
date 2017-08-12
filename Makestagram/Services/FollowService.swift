//
//  FollowService.swift
//  Makestagram
//
//  Created by Cameron Long on 7/12/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService {
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    /*
     method to follow users
    */
    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            
            let dispatchGroup = DispatchGroup()
            
            //new group has entered
            dispatchGroup.enter()
            
            // HOW do transaction blocks and dispatchgroups interact?
            //why do we enter a dispatch group, leave it and then enter a new one? why not stay in the same one?
            //how should i visualize dispatch groups?
            let followingCountRef = Database.database().reference().child("users").child(currentUID).child("following_count")
            followingCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                // 4
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            })
            
            // 5
            dispatchGroup.enter()
            let followerCountRef = Database.database().reference().child("users").child(user.uid).child("follower_count")
            followerCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            })
            
            // add users posts to current users timeline
            dispatchGroup.enter()
            UserService.posts(for: user) { (posts) in
                let postKeys = posts.flatMap { $0.key }
                
                var followData = [String : Any]()
                let timelinePostDict = ["poster_uid" : user.uid]
                postKeys.forEach { followData["timeline/\(currentUID)/\($0)"] = timelinePostDict }
                
                ref.updateChildValues(followData, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                })
            }
            
            // notify
            dispatchGroup.notify(queue: .main) {
                success(true)
            }
        }
    }
    
    /*
     method to unfollower users
     */
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        // http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            let followingCountRef = Database.database().reference().child("users").child(currentUID).child("following_count")
            followingCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount - 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            let followerCountRef = Database.database().reference().child("users").child(user.uid).child("follower_count")
            followerCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount - 1
                
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                }
                
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            UserService.posts(for: user, completion: { (posts) in
                var unfollowData = [String : Any]()
                let postsKeys = posts.flatMap { $0.key }
                postsKeys.forEach {
                    // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
                    unfollowData["timeline/\(currentUID)/\($0)"] = NSNull()
                }
                
                ref.updateChildValues(unfollowData, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    dispatchGroup.leave()
                })
            })
            
            dispatchGroup.notify(queue: .main) {
                success(true)
            }
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("followers").child(user.uid)
        let currentUID = User.current.uid
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
}
