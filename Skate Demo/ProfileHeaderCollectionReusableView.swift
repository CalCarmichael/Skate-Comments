//
//  ProfileHeaderCollectionReusableView.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 20/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userPostCountLabel: UIStackView!
    
    @IBOutlet weak var followingCountLabel: UIStackView!
    
    @IBOutlet weak var followerCounterLabel: UIStackView!
    
    var user: User? {
        
        didSet {
            updateView()
        }
        
    }
    
    func updateView() {
            
            self.nameLabel.text = user!.username
            
            if let photoUrlString = user!.profileImageUrl {
                
            let photoUrl = URL(string: photoUrlString)
                
            self.profileImage.sd_setImage(with: photoUrl)
                
            }
        }
        
    }
    
