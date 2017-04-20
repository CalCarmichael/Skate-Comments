//
//  PostApi.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 19/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import Firebase

//Api for the post method and getting posts from the database

class PostApi {
    
    var REF_POSTS = FIRDatabase.database().reference().child("posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
         
            if let dict = snapshot.value as? [String: Any] {
                
            let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
            
             completion(newPost)
                
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
     
        REF_POSTS.child(id).observeSingleEvent(of: FIRDataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
                
            }
        })
        
    }
    
}
