//
//  UserApi.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 19/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

class UserApi {
    
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        })
    }
    
    func observeCurrentUser(completion: @escaping (User) -> Void) {
     
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
                
            }
            
        })
        
    }
    
    var CURRENT_USER: FIRUser? {
        if let currentUser = FIRAuth.auth()?.currentUser {
            return currentUser
        }
        
        return nil
        
    }
    
    //Query reference to the user on the database 
    
    var REF_CURRENT_USER: FIRDatabaseReference? {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
        
    }

}
