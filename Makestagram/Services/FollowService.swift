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
        // Dictionary to update multiple locations at once
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
                          "following/\(currentUID)/\(user.uid)" : true]
        
        // write relationship to database
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
    
    /*
     method to unfollower users
     */
    private static func unfollowUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        // http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
        let currentUID = User.current.uid
        let unfollowData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                            "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        //write relationship to database
        let ref = Database.database().reference()
        ref.updateChildValues(unfollowData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
         success(error == nil)
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
