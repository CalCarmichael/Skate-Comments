//
//  CommentViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 18/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class CommentViewController: UIViewController {
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentConstrainToBottom: NSLayoutConstraint!
    
    let postId = "-Ki5D10aIs2oQjC189vZ"
    
    var comments = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        empty()
        handleTextField()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    func keyboardWillShow(_ notification: NSNotification) {
        print(notification)
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        print(keyboardFrame)
        UIView.animate(withDuration: 0.25) {
            
            self.commentConstrainToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
        
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.25) {
            self.commentConstrainToBottom.constant = 0
            self.view.layoutIfNeeded()
    }
        
    }
    
    func loadComments() {
        
        let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId)
        postCommentRef.observe(.childAdded, with: {
            snapshot in
            print("observe key")
            print(snapshot.key)
            FIRDatabase.database().reference().child("comments").child(snapshot.key).observeSingleEvent(of: .value, with: {
                snapshotComment in
                
                if let dict = snapshotComment.value as? [String: Any] {
                    
                    //Retrieving from the database - comment Model created class
                    
                    let newComment = Comment.transformComment(dict: dict)
                    
                    self.getUser(uid: newComment.uid!, completed: {
                        
                        self.comments.append(newComment)
                        
                        self.tableView.reloadData()
                        
                    })
                    
                    
                    
                }
            })
        })
        
    }
    
    func getUser(uid: String, completed: @escaping () -> Void) {
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: FIRDataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                self.users.append(user)
                completed()
            }
        })
        
        
        
    }
    
    
    func handleTextField() {
        
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        if let commentTextField = commentTextField.text, !commentTextField.isEmpty {
            sendButton.setTitleColor(UIColor.black, for: UIControlState.normal)
            sendButton.isEnabled = true
            return
        }
        
        sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        
        let ref = FIRDatabase.database().reference()
        let commentsReference = ref.child("comments")
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentText": commentTextField.text!], withCompletionBlock: {
            (error, ref) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            
            let postCommentRef = FIRDatabase.database().reference().child("post-comments").child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            
            self.empty()
            self.view.endEditing(true)
            
        })
        
        
    }
    
    //Empty out comment message after comment sent
    
    func empty() {
        
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        self.sendButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    
}

extension CommentViewController: UITableViewDataSource {
    
    //Rows in table view - returning posts
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
        
    }
    
    //Customise rows
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Reuses the cells shown rather than uploading all of them at once
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        //Posting the user information from Folder Views - FeedTableViewCell
        
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
    
}

