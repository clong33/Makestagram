//
//  ProfileHeaderView.swift
//  Makestagram
//
//  Created by Cameron Long on 8/15/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        print("settings button tapped")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        settingsButton.layer.cornerRadius = 6
        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
        settingsButton.layer.borderWidth = 1
    }
    
}
