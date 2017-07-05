//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Cameron Long on 7/4/17.
//  Copyright © 2017 Cameron Long. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        // 1
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        // 2
        authUI.delegate = self
        
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
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

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("error signing in: \(error.localizedDescription)")
            return
        }
        
        //First we check that the FIRUser returned from authentication is not nil by unwrapping it. We guard this statement, because we cannot proceed further if the user is nil. We need the FIRUser object's uid property to build the relative path for the user at users/#{uid}.
        guard let user = user
            else { return }
        
        //We construct a relative path to the reference of the user's information in our database.
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        //We read from the path we created and pass an event closure to handle the data (snapshot) that is passed back from the database.
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        
            //To retrieve the user data from DataSnapshot, we check that the snapshot exists, and that it is of the expected Dictionary type. Based on whether the user dictionary exists, we'll know whether the current user is a new or returning user.
            if let userDict = snapshot.value as? [String : Any] {
                print("User already exists \(userDict.debugDescription).")
            } else {
                print("New user!")
            }
        })
        
    }
}
