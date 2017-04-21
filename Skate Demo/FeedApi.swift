//
//  FeedApi.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

class FeedApi {
    
    var REF_FEED = FIRDatabase.database().reference().child("feed")
    
    //Instance method to observe posts of each user
    
    func observeFeed(withId id: String, completion: @escaping (Post) -> Void) {
        
        REF_FEED.child(id).observeSingleEvent(of: .childAdded, with: {
            
            snapshot in
            
            let key = snapshot.key
            
            Api.Post.observePost(withId: key, completion: { (post) in
                
                completion(post)
            })
                
            })
            
     
        
    }
    
    //Return the posts that were just removed after the unfollow action 
    
    func observeFeedRemoved(withId id: String, completion: @escaping (String) -> Void) {
        
        REF_FEED.child(id).observe(.childRemoved, with: {
            
            snapshot in
            
            let key = snapshot.key
            
            completion(key)
            
        })
        
    }
    
    
}

