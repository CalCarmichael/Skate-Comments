//
//  CameraViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 04/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import ProgressHUD

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearPostButton: UIBarButtonItem!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCameraPhoto))
        cameraImage.addGestureRecognizer(tapGesture)
        cameraImage.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleImagePost()
    }
    
    //Checks if photo is in UIImage. Post button change colour dependant on this.
    
    func handleImagePost() {
        
        if selectedImage != nil {
            
            self.shareButton.isEnabled = true
            self.clearPostButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
        } else {
            
            self.shareButton.isEnabled = false
            self.clearPostButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    //Getting photo
    
    func handleCameraPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //Sharing photo
    
    @IBAction func shateButton_TouchUpInside(_ sender: Any) {
        
        view.endEditing(true)
        
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            HelperService.uploadDataToServer(data: imageData, caption: captionTextView.text!, onSuccess: {
                
                self.clearPost()
                self.tabBarController?.selectedIndex = 3
                
            })
            
        } else {
            
            ProgressHUD.showError("Profile Image must be chosen")
            
        }
        
    }
    
    //Cancel photo post
    
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        
        clearPost()
        handleImagePost()
        
    }
    
    func clearPost() {
        
        self.captionTextView.text = ""
        self.cameraImage.image = UIImage(named: "image-placeholder")
        self.selectedImage = nil
    }
    
}

//Getting photo with image picker

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("did finish pick")
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            cameraImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
