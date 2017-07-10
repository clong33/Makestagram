//
//  PostService.swift
//  Makestagram
//
//  Created by Cameron Long on 7/10/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    static func create(for image: UIImage) {
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            self.create(forURLString: urlString, aspectHeight: image.aspectHeight)
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        //create new post in database
        // get user reference
        let currentUser = User.current
        // create post
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        // compute dictionary of post that contains time at which post was created, image url, and image height
        let dict = post.dictValue
        
        // get path to place post
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        //place post in database
        postRef.updateChildValues(dict)
    }
}
