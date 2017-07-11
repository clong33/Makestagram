//
//  File.swift
//  Makestagram
//
//  Created by Cameron Long on 7/10/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        print("options button tapped")
    }
}
