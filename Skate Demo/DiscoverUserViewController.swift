//
//  DiscoverUserViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class DiscoverUserViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
        
    }
    
    func loadUsers() {
        
        Api.User.observeLoadUsers { (user) in
            
            self.isFollowing(userId: user.id!, completed: { (value) in
                
                user.isFollowing = value
                
                self.users.append(user)
                self.tableView.reloadData()
                
            })
            
            
        }
        
    }
    
    //Use user id input to look at database and see if current user is following user
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        
        Api.Follow.isFollowing(userId: userId, completed: completed)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ViewingProfileSegue" {
            
            let userProfileVC = segue.destination as! UserViewProfileViewController
            
            let userId = sender as! String
            
            userProfileVC.userId = userId
        }
        
    }

}

extension DiscoverUserViewController: UITableViewDataSource {
    
    //Rows in table view - returning users
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reuses the cells shown rather than uploading all of them at once
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverUserTableViewCell", for: indexPath) as! DiscoverUserTableViewCell
        
        //Extracting the user object from user array 
        
        let user = users[indexPath.row]
        
        cell.user = user
        
        cell.userProfileVC = self
        
        return cell
    }
    
}
