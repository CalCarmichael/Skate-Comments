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
        
     //   followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
        
        followButton.addTarget(self, action: #selector(self.unfollowAction), for: UIControlEvents.touchUpInside)
        
    }
    
    func followAction() {
     
        //Corresponding users - switch when pressing in corresponding list within database
        
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).setValue(true)
        
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).setValue(true)
        
    }
    
    func unfollowAction() {
        
        //NSNull - removes the child from child list of parent node
        
        Api.Follow.REF_FOLLOWERS.child(user!.id!).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(user!.id!).setValue(NSNull())
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
