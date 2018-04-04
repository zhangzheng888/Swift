//
//  Student.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/8/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

struct Student {
    
    // MARK: Properties
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    
    // MARK: Initialization
    
    init(dictionary: [String:AnyObject]) {
        firstName =  dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
    }
    
    // MARK: Helpers
    
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
}
