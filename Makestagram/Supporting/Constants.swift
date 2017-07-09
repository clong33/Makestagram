//
//  Constants.swift
//  Makestagram
//
//  Created by Cameron Long on 7/7/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation

struct Constants {
    struct Segue {
        static let toCreateUsername = "toCreateUsername"
    }
    
    struct UserDefaults {
        static let username = "username"
        static let uid = "uid"
        static let currentUser = "currentUser"
    }
    
    struct TabBarItems {
        static let home = 0
        static let picture = 1
        static let friends = 2
    }
}
