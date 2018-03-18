//
//  Student.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/8/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

struct Student {
    
    // MARK: Properties
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: URL?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?

//    init(objectId: String, uniqueKey: String?, firstName: String?, lastName: String?, mediaURL: String?, latitude: Double?, longitude: Double?, mapString: String?) {
//        self.objectId = objectId
//        self.uniqueKey = uniqueKey
//        self.firstName = firstName
//        self.lastName = lastName
//        if let url = URL(string: mediaURL ?? "") {
//            self.mediaURL = url
//        } else {
//            self.mediaURL = nil
//        }
//
//        self.latitude = latitude
//        self.longitude = longitude
//        self.mapString = mapString
//    }
    
    init(dictionary: [String:AnyObject]) {
//        self.objectId = getValue(from: dictionary, for: "objectId") as! String?
//        self.firstName = getValue(from: dictionary, for: "firstName") as! String?
//        self.lastName = getValue(from: dictionary, for: "lastName") as! String?
//        self.uniqueKey = getValue(from: dictionary, for: "uniqueKey") as! String?
//        if let url = URL(string: getValue(from: dictionary, for: "mediaURL") as! String? ?? "") {
//            self.mediaURL = url
//        } else {
//            self.mediaURL = nil
//        }
//
//        self.latitude = getValue(from: dictionary, for: "latitude") as! Double?
//        self.longitude = getValue(from: dictionary, for: "longitude") as! Double?
//        self.mapString = getValue(from: dictionary, for: "mapString") as! String?
        firstName =  dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? URL
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [Student] {
        
        var locations = [Student]()
        
        for eachLocation in results {
            locations.append(Student(dictionary: eachLocation))
        }
        return locations
    }
    
    static func userLocationFromResults(_ results: [[String:AnyObject]]) -> Student? {
        
        var userLocations = results
        var userLocation: Student?
        
        if let currentLcation = userLocations.popLast() {
            userLocation = Student(dictionary: currentLcation)
        }
        
        return userLocation
        
    }
    
//    func userLocationFromResults(_ results: [[String:AnyObject]]) -> Student? {
//
//        var userLocations = results
//        var eachLocation = Student?
//
//        if let latestLocation = userLocations.popLast() {
//            eachLocation = Student(dictionary: latestLocation)
//        }
//
//        return eachLocation
//    }
    
    // MARK: Helpers
    
    private func getValue(from dictionary: [String: AnyObject], for key: String) -> AnyObject? {
        if let value = dictionary[key] {
            return value
        } else {
            return nil
        }
    }
}
