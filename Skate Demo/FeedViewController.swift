//
//  FeedViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 521
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadPosts()
        
        
    }
    
    //Retrieving the posts from the database with child added - updates only what we want not everything
    
    func loadPosts() {
        
        //Activity loading animation start - then stops before reloading data
        
        activityIndicatorView.startAnimating()
        
        FIRDatabase.database().reference().child("posts").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                //Retrieving from the database - post Model created class
                
                let newPost = Post.transformPostPhoto(dict: dict)
                
                self.getUser(uid: newPost.uid!, completed: {
                    
                    self.posts.append(newPost)
                    
                    self.activityIndicatorView.stopAnimating()
                    
                    self.tableView.reloadData()
                    
                })
                    
               
                
            }
            
        }
        
    }
    
    func getUser(uid: String, completed: @escaping () -> Void) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Keeps the tab bar on this page rather than removing in comments
        
        self.tabBarController?.tabBar.isHidden = false
    
    //Look up the right user on the database (escaping means having no input return nothing)
    
    func getUser(uid: String, completed: @escaping () -> Void) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                
                //Retrieving from the database - Model User created class
                
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
               
                
            }
            
        })

        
    }
    
  }
    
}

extension FeedViewController: UITableViewDataSource {
    
    //Rows in table view - returning posts
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return posts.count
        
    }
    
    //Customise rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reuses the cells shown rather than uploading all of them at once
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! FeedTableViewCell
        
        //Posting the user information from Folder Views - FeedTableViewCell
        
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
}


