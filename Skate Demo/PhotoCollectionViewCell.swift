//
//  PhotoCollectionViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 21/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Photo: UIImageView!
    
    
    var post: Post? {
        didSet {
            
            updateView()
            
        }
    }
    
    func updateView() {
        
        if let photoUrlString = post?.photoUrl {
            
            let photoUrl = URL(string: photoUrlString)
            Photo.sd_setImage(with: photoUrl)
            
        }
        
    }
    
}
