//
//  userPostApi.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 20/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

class userPostApi {
    
    var REF_USER_POSTS = FIRDatabase.database().reference().child("userPosts")
    
}
