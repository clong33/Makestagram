//
//  StorageService.swift
//  Makestagram
//
//  Created by Cameron Long on 7/10/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

struct StorageService {
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
            return completion(nil)
        }
        
        // upload media to path specified by reference
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // return the download URL for the image
            completion(metadata?.downloadURL())
        })
    }
}
