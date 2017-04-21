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
    
    func followAction(withUser id: String) {
        
        //Corresponding users - switch when pressing in corresponding list within database
        
       REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        
       REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
        
    }
    
    func unfollowAction(withUser id: String) {
        
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
        
        
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            
            snapshot in
            
            //If null user not in follower list of this user
            
            if let _ = snapshot.value as? NSNull {
                
                completed(false)
                
            } else {
                
                completed(true)
                
            }
            
            
            
        })
        
    }
    
}
