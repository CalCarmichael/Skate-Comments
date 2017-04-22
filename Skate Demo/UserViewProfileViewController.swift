//
//  UserViewProfileViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 22/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class UserViewProfileViewController: UIViewController {
    
    var user: User!
    
    var posts: [Post] = []
    
    var userId = ""
    
    @IBOutlet weak var userViewCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("userId: \(userId)")
        
        userViewCollectionView.dataSource = self
        userViewCollectionView.delegate = self
        
        getUser()
        getUserPosts()
        

        
    }
    
    func getUser() {
        
        Api.User.observeUser(withId: userId) { (user) in
            
            self.user = user
            
            self.navigationItem.title = user.username
            
            self.userViewCollectionView.reloadData()
            
        }
        
    }
    
    func getUserPosts() {
        
        Api.userPosts.REF_USER_POSTS.child(userId).observe(.childAdded, with: {
            
            snapshot in
            
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                self.posts.append(post)
                self.userViewCollectionView.reloadData()
                
            })
            
        })
    }

}

extension UserViewProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        //Display posts at certain array index on corresponding row
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    //Supply Header to collection view
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as! ProfileHeaderCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
        }
        
        return headerViewCell
    }
    
}

//Creating the UI for the cells on profile page

extension UserViewProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 , height: collectionView.frame.size.width / 3)
    }
    
}
