//
//  Post.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation

class Post {
    
    var caption: String?
    var photoUrl: String?
    var uid: String?
    
}

extension Post {
    
    //Instance method put into load posts
    
    static func transformPostPhoto(dict: [String: Any]) -> Post {
        
        let post = Post()
        
        post.caption = dict["caption"] as? String
        
        post.photoUrl = dict["photoUrl"] as? String
        
        post.uid = dict["uid"] as? String
        
        return post
    }
    
    static func transformPostVideo() {
        
    }
    
}
