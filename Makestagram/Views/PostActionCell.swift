//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Cameron Long on 7/11/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit

class PostActionCell: UITableViewCell {
    
    //MARK: - Subviews
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    static let height: CGFloat = 46
    
    //MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBActions
    @IBAction func likesButtonTapped(_ sedner: UIButton) {
        print("likes button tapped")
    }
}
