//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Cameron Long on 7/6/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateUsernameViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 6
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
                //Get reference to the current window and set the rootViewController to the initial view controller
                self.view.window?.rootViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.makeKeyAndVisible()
            
        }
    }
    
    
}
