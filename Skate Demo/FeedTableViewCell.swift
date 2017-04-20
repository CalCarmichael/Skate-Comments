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
    
    var postRef: FIRDatabaseReference!
    
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
        
        Api.Post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post .transformPostPhoto(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }

        })
       
    
        Api.Post.REF_POSTS.child(post!.id!).observe(.childChanged, with: {
            snapshot in
            
            if let value = snapshot.value as? Int {
                self.likeCountButton.setTitle("\(value) Like", for: UIControlState.normal)
            }
            
        })
        
        
    }
    
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

        postRef = Api.Post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef: postRef)
        
    }
    
    //Get the current post data on database, increase or decrease like data then push change to database
    
    func incrementLikes(forRef ref: FIRDatabaseReference) {
        
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                
                print("value 1: \(currentData.value)")
                
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post .transformPostPhoto(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
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
