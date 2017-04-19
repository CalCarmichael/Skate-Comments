//
//  CommentTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 18/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var comment: Comment? {
        didSet {
            
            updateViewComment()
            
            
        }
    }
    
    var user: User? {
        didSet {
            
            setUserInfo()
            
        }
    }
    
    func updateViewComment() {
        commentLabel.text = comment?.commentText
    }
    
    func setUserInfo() {
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImage"))
        }
        
    }
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            nameLabel.text = ""
            commentLabel.text = ""
            
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImage")
    }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
            
        }
    }
