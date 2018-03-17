//
//  ParseConvenience.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/14/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: GET Convenience
    func getStudentLocation(_ completionHandlerForStudentLocation: @escaping (_ success: Bool, _ result: Student?, _ error: String?) -> Void) {
        
        let parameters = [ParameterKeys.Where: "{\"\(ParameterKeys.UniqueKey)\":\"" + "\(uniqueKey)" + "\"}"] as [String:AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters, completionHandlerForGET: {(result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForStudentLocation(false, nil, "Get User Location Failed.")
            } else {
                
                guard let result = result?["results"] as? [[String:AnyObject]], !result.isEmpty else {
                    print("User Location not found!")
                    return
                }
                
                if let location = Student.userLocationFromResults(result) {
                    userLocation = location
                    completionHandlerForStudentLocation(true, userLocation, nil)
                }
            }
        })
    }

    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ success: Bool, _ students: [Student]?, _ error: String?) -> Void) {
        
        let parameters = ["limit": "100", "order": "-updatedAt"] as [String: AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters, completionHandlerForGET: {(result, error) in
            
            if let error = error {
                print(error)
                completionHandlerForStudentLocations(false, nil, "Get Student Locations Failed.")
            } else {
                
                if let result = result?["results"] as? [[String:AnyObject]] {
                    
                    let locations = Student.studentLocationsFromResults(result)
                    StudentData.sharedInstance.studentLocations = locations
                    completionHandlerForStudentLocations(true, locations, nil)
                    
                } else {
                    print("JSON Parse Error")
                }
            }
        })
    }
}
