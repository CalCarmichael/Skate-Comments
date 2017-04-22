//
//  DiscoverUserTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class DiscoverUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    var userProfileVC: UserViewProfileViewController?
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    
    
    func updateView() {
        
        //Set name label on cell to username of user variable
        
        nameLabel.text = user?.username
        
        //Setting user profile image
        
        if let photoUrlString = user?.profileImageUrl {
            
            let photoUrl = URL(string: photoUrlString)
            
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImage"))
            
        }
        
        //Check if current user is following
        
        
        
        if user!.isFollowing! {
        
            configureUnFollowButton()

        } else {
        
            configureFollowButton()
        
        }
        
    }
    
        func configureFollowButton() {
            
            //UI Button
            
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
            followButton.layer.cornerRadius = 5
            followButton.clipsToBounds = true
            followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
            
            followButton.setTitle("Follow", for: UIControlState.normal)
            followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
            
            
        }
        
        func configureUnFollowButton() {
            
            //UI Button
            
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232.255, alpha: 1).cgColor
            followButton.layer.cornerRadius = 5
            followButton.clipsToBounds = true
            followButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            followButton.backgroundColor = UIColor(red: 66/255, green: 244/255, blue: 75/255, alpha: 1)
            
            followButton.setTitle("Following", for: UIControlState.normal)
            followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControlEvents.touchUpInside)
            
        }
    
    
    //followAction and unfollowAction within FollowApi
    
    func followAction() {
        
        
        if user!.isFollowing! == false {
            
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            
            user!.isFollowing! = true
        }
        
        
    }
    
    func unfollowAction() {
        
        if user!.isFollowing! == true {
            
            Api.Follow.unfollowAction(withUser: user!.id!)
            configureFollowButton()
            
            user!.isFollowing! = false
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Tapping username gesture. Takes to UserViewProfile
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGesture)
        nameLabel.isUserInteractionEnabled = true
        
    }
    
    func nameLabel_TouchUpInside() {
        
        if let id = user?.id {
            
            userProfileVC?.performSegue(withIdentifier: "ViewingProfileSegue", sender: id)
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
