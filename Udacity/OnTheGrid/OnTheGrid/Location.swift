//
//  Location.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/9/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import MapKit

struct Location {
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var coordinate: CLLocationCoordinate2D?
    
    init(latitude: Double?, longitude: Double?, mapString: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        if latitude != nil && longitude != nil {
            self.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        } else {
            self.coordinate = nil
        }
        
    }
    
    init(dictionary: [String: AnyObject]) {
        self.latitude = getValue(from: dictionary, for: "latitude") as! Double?
        self.longitude = getValue(from: dictionary, for: "longitude") as! Double?
        self.mapString = getValue(from: dictionary, for: "mapString") as! String?
        if latitude != nil && longitude != nil {
            self.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        } else {
            self.coordinate = nil
        }
    }
    
    func getValue(from dictionary: [String: AnyObject], for key: String) -> AnyObject? {
        if let value = dictionary[key] {
            return value
        } else {
            return nil
        }
    }
}
