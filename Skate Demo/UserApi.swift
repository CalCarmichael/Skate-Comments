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
    
}
