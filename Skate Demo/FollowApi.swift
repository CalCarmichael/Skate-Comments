//
//  FollowApi.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

class FollowApi {
    
    var REF_FOLLOWERS = FIRDatabase.database().reference().child("followers")
    
    var REF_FOLLOWING = FIRDatabase.database().reference().child("following")
    
}
