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
