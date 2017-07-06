//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Cameron Long on 7/6/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit

class CreateUsernameViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 6
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
