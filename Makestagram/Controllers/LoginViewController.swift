//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Cameron Long on 7/4/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        print("log in button tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
