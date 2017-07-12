//
//  PostActionCell.swift
//  Makestagram
//
//  Created by Cameron Long on 7/11/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: PostActionCellDelegate?
    
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
    @IBAction func likesButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
}
