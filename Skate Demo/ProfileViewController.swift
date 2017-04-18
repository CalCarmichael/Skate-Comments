//
//  ProfileViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 04/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

   
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
   
    try FIRAuth.auth()?.signOut()
    
        } catch let logoutError {
            print(logoutError)
        }
        
        //When logging out send back to the sign in view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
    
    }
}
