//
//  HelperService.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import ProgressHUD
import Firebase

class HelperService {
    
    static func uploadDataToServer(data: Data, caption: String, onSuccess: @escaping () -> Void) {
        
        //Creating UniqueID for photos users post
        
        let photoIdString = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("posts").child(photoIdString)
        
        storageRef.put(data, metadata: nil) { (metadata, error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
                
            }
            
            //Send data to database
            
            let photoUrl = metadata?.downloadURL()?.absoluteString
            
            self.sendDataToFirebase(photoUrl: photoUrl!, caption: caption, onSuccess: onSuccess)
            
        }
    }
    
    //Send data to database with unqiue post id
    
    static func sendDataToFirebase(photoUrl: String, caption: String, onSuccess: @escaping () -> Void) {
        
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        
        let newPostReference = Api.Post.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "caption": caption, "likeCount": 0], withCompletionBlock: {
            (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            //Once post registered store it in feed corresponding to current user. newPostId creates new node
            
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId).setValue(true)
            
            let userPostRef = Api.userPosts.REF_USER_POSTS.child(currentUserId).child(newPostId)
            userPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            
            ProgressHUD.showSuccess("Success")
            
            onSuccess()
            
        })
        
        
    }
    
}
