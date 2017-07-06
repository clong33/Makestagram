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
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
        
            if let user = User(snapshot: snapshot) {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                User.setCurrent(user)
                
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            } else {
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
            }
        })
        
    }
}
