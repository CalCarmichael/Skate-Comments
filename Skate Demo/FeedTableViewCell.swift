//
//  FeedTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var dislikeImageView: UIImageView!
    @IBOutlet weak var commentView: UIImageView!
    @IBOutlet weak var shareView: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var captionLabel: UILabel!
    
    //Created an instance variable
    
    var feedVC: FeedViewController?
    
    var post: Post? {
        didSet {
            
            updateViewPost()
            
            
        }
    }
    
    var user: User? {
        didSet {
            
            setUserInfo()
            
        }
    }
    
    func updateViewPost() {
        
        captionLabel.text = post?.caption
        
        //Getting photo url from database
        
        if let photoUrlString = post?.photoUrl {
            
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
            
        }
        
        //User liking post and heart changing colour
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: {
                snapshot in
                print(snapshot)
                if let _ = snapshot.value as? NSNull {
                    self.likeImageView.image = UIImage(named: "Like")
                } else {
                    self.likeImageView.image = UIImage(named: "Like Filled")
                }
                
            })
            
        }

        
    }
    
    //Grabbing all user information its observing and retrieving from specific user uid
    
    func setUserInfo() {
        
        usernameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImage"))
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        usernameLabel.text = ""
        captionLabel.text = ""
        
        //Comment button bubble to comments page
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentView_TouchUpInside))
        commentView.addGestureRecognizer(tapGesture)
        commentView.isUserInteractionEnabled = true
        
        let tapGestureForLikeImageView = UITapGestureRecognizer(target: self, action: #selector(self.likeImageView_TouchUpInside))
        likeImageView.addGestureRecognizer(tapGestureForLikeImageView)
        likeImageView.isUserInteractionEnabled = true
        
    }
    
    //Like image when pressed sent to database
    
    func likeImageView_TouchUpInside() {

        if let currentUser = FIRAuth.auth()?.currentUser {
            Api.User.REF_USERS.child(currentUser.uid).child("likes").child(post!.id!).observeSingleEvent(of: .value, with: {
                snapshot in
                
                if let _ = snapshot.value as? NSNull {
                    
                Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).setValue(true)
                    
                self.likeImageView.image = UIImage(named: "Like Filled")
                    
                } else {
                    
                    Api.User.REF_USERS.child(currentUser.uid).child("likes").child(self.post!.id!).removeValue()
                    
                    self.likeImageView.image = UIImage(named: "Like")
                    
                }
                
            })
            
        }

        
    }
    
    //Comment image to comment view
    
    func commentView_TouchUpInside() {
        print("touched")
        if let id = post?.id {
            feedVC?.performSegue(withIdentifier: "CommentSegue", sender: id)

        }
    }
    
    //Deletes all old data
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("1111")
        profileImageView.image = UIImage(named: "placeholderImage")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
