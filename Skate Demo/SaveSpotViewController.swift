//
//  SaveSpotViewController.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 12/04/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class SaveSpotViewController: UIViewController {
    
    @IBOutlet weak var skateTitleText: UITextField!
    @IBOutlet weak var skateStyleText: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var options = ["Select Type", "Skatepark", "Street Skating", "Personal Spots"]
    
    var skateparks = [Skatepark]()
    
    var user: FIRUser!
    
    var locationManager = CLLocationManager()
    
    let locationsRef = FIRDatabase.database().reference(withPath: "locations")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    @IBAction func addPinAndSaveLocation(_ sender: Any) {
    
        let userLocationCoordinates = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        
        let pinForUserLocation = MGLPointAnnotation()
        
        pinForUserLocation.coordinate = userLocationCoordinates
        
        let selected = pickerView.selectedRow(inComponent: 0)
        
        guard selected > 0 else {
            print("select a type")
            return
        }
        
      guard let skateTitleText = skateTitleText.text, let skateStyleText = skateStyleText.text else { return }
    
        guard skateTitleText.characters.count > 0, skateStyleText.characters.count > 0 else {
            
            return
            
        }
        
        //When the user clicks the button, send the CLLocation Coordinate 2D make to firebase against their user ID
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        let locationsRef = FIRDatabase.database().reference().child("users").child(uid).child("personalLocations").childByAutoId()
        
        locationsRef.setValue(["lat": locationManager.location?.coordinate.latitude, "lng": locationManager.location?.coordinate.longitude, "name": skateTitleText, "subtitle": skateStyleText, "type": (selected - 1)])
        
        
    }

}

extension SaveSpotViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
}

extension SaveSpotViewController: UIPickerViewDataSource {
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    
}

