//
//  FeedTableViewCell.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 06/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import ProgressHUD

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

        //Observing the like button being changed and updating from other users
        
        self.updateLike(post: self.post!)
        
    }
    
    
        //Observing likes given the id of the post
        
      
    
    //Check if user has liked image before. If they have = like filled. If not = like
    
    func updateLike(post: Post) {
        
        let imageName = post.likes == nil  || !post.isLiked! ? "Like" : "Like Filled"
        
        likeImageView.image = UIImage(named: imageName)
        
        //Checking and updating Like status
        
        guard let count = post.likeCount else {
            
            return 
            
        }
        
        if count != 0 {
            
            likeCountButton.setTitle("\(count) Like", for: UIControlState.normal)
            
        } else {
            
            likeCountButton.setTitle("Like this first!", for: UIControlState.normal)
            
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
        
        Api.Post.incrementLikes(postId: post!.id!, onSuccess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
        
        //incrementLikes(forRef: postRef)
        
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
