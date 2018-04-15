//
//  ParseConvenience.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/14/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

extension ParseClient {
    
    typealias getLocationCompletionHandler = (_ success: Bool, _ result: Student?, _ error: String?) -> Void
    typealias getLocationsCompletionHandler = (_ success: Bool, _ students: [Student]?, _ error: String?) -> Void
    typealias clientCompletionHandler = (_ success: Bool, _ error: Error?) -> Void
    
    enum ClientError: Error {
        case request(description: String)
        case parse
    }
    
    // MARK: GET Convenience
    
    func getStudentLocation(_ completionHandlerForStudentLocation: @escaping getLocationCompletionHandler) {
        
        let parameters = [ParameterKeys.Where: "{\"\(ParameterKeys.UniqueKey)\":\"" + "\(uniqueKey)" + "\"}"] as [String:AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters, completionHandlerForGET: {(result, error) in

            if let error = error {
                print(error)
                completionHandlerForStudentLocation(false, nil, "Get User Location Failed.")
            } else if let result = result?["results"] as? [[String:AnyObject]], !result.isEmpty{
                print(result)
                let location = Student.userLocationFromResults(result)
                userLocation = location!
                completionHandlerForStudentLocation(true, userLocation, nil)
            } else {
                print("User Location not found!")
                completionHandlerForStudentLocation(false, nil, ClientError.parse.localizedDescription)
            }
        })
    }

    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping getLocationsCompletionHandler) {
        
        let parameters = [ParameterKeys.Limit: ParameterValues.LimitValue, ParameterKeys.Order: ParameterValues.LatestOrderValue] as [String: AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters, completionHandlerForGET: {(result, error) in
           if let error = error {
                print(error)
                completionHandlerForStudentLocations(false, nil, "Get Student Locations Failed.")
            } else if let result = result?["results"] as? [[String:AnyObject]] {
                print(result)
                let locations = Student.studentLocationsFromResults(result)
                StudentData.sharedInstance.studentLocations = locations
                completionHandlerForStudentLocations(true, locations, nil)
            } else {
                print("JSON Parse Error")
                completionHandlerForStudentLocations(false, nil, ClientError.parse.localizedDescription)
            }
        })
    }
    
    func postStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longitude: Double, _ completionhandlerForPOSTStudentLocation: @escaping clientCompletionHandler) {
        
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(userLocation.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(userLocation.lastName!)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = taskForPOSTMethod(Method.StudentLocation, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            if let error = error {
                completionhandlerForPOSTStudentLocation(false, ClientError.request(description: error.localizedDescription))
            } else if let objectID = result?[JSONResponseKeys.ObjectID] as? String {
                    userLocation.objectId = objectID
                    completionhandlerForPOSTStudentLocation(true, nil)
            } else {
                    completionhandlerForPOSTStudentLocation(false, ClientError.parse)
            }
        })
    }
    
    func putStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longitude: Double, _ completionhandlerForPUTStudentLocation: @escaping clientCompletionHandler) {
        
        let latitude = String(latitude)
        let longitude = String(longitude)
        
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(userLocation.uniqueKey!)\",\"\(JSONBodyKeys.FirstName)\": \"\(userLocation.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(userLocation.lastName!)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = taskForPUTMethod("\(Method.StudentLocation)"+"/\(userLocation.objectId!)", jsonBody, completionHandlerForPUT: {(result, error) in
            if let error = error {
                completionhandlerForPUTStudentLocation(false, ClientError.request(description: error.localizedDescription))
            } else {
                completionhandlerForPUTStudentLocation(true, nil)
            }
        })
    }
}
