//
//  Skatepark.swift
//  Skate Demo
//
//  Created by Callum Carmichael (i7726422) on 22/03/2017.
//  Copyright © 2017 Callum Carmichael (i7726422). All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation


enum SkateType: Int {
    case park = 0, street, own
}

class Skatepark {
    
    let coordinate: CLLocationCoordinate2D!
    let name: String!
    let subtitle: String!
    let type: SkateType
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        subtitle = snapshotValue["subtitle"] as! String
        coordinate = CLLocationCoordinate2D(latitude: snapshotValue["lat"] as! Double, longitude: snapshotValue["lng"] as! Double)
        type = SkateType(rawValue: snapshotValue["type"] as! Int)!
    
    }

}







