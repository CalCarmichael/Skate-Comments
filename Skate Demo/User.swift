//
//  User.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 11/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var email: String?
    var profileImageUrl: String?
    var username: String?
    

}

extension User {
    static func transformUser(dict: [String: Any]) -> User {
        
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        
        return user
        
    }
}
