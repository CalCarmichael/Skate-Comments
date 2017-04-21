//
//  ProfileViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 04/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        getUser()
        getUserPosts()
        
    }
    
    //Getting user info and attributes from PHCRView
    
    func getUser() {
        
        Api.User.observeCurrentUser { (user) in
            
            self.user = user
            self.collectionView.reloadData()
            
        }
        
    }
    
    func getUserPosts() {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        Api.userPosts.REF_USER_POSTS.child(currentUser.uid).observe(.childAdded, with: {
            snapshot in
            //Data snapshot containing all posts shared by current user or new post just added
            
            Api.Post.observePost(withId: snapshot.key, completion: {
                post in
                print(post.id)
                self.posts.append(post)
                self.collectionView.reloadData()
                
            })
            
        })
    }
    
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            
            try FIRAuth.auth()?.signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
        
        //When logging out send back to the sign in view controller
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.present(signInVC, animated: true, completion: nil)
        
    }
}


extension ProfileViewController: UICollectionViewDataSource {
    
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

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
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
