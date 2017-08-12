//
//  DatabaseReference+Location.swift
//  Makestagram
//
//  Created by Cameron Long on 8/9/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseReference {
    enum MGLocation {
        case root
        case posts(uid: String)
        case showPost(uid: String, posterKey: String)
        case showLikes(uid: String, key: String)
        
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            switch self {
            case .root:
                return root
            case .posts(let uid):
                return root.child("posts").child(uid)
            case .showPost(let uid, let key):
                return root.child("users").child(uid).child(key)
            case .showLikes(let uid, let key):
                return root.child("postLikes").child(key).child(uid)
                
            }
        }
    }
    
    static func toLocation(_ location: MGLocation) -> DatabaseReference {
        return location.asDatabaseReference()
    }
}
