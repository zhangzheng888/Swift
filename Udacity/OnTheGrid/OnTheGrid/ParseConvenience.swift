//
//  ParseConvenience.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/14/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

typealias clientSuccessCompletionHandler = (_ success: Bool, _ error: Error?) -> Void

extension ParseClient {
    enum ClientError : Error {
        case errorWith(description:String)
        case parseData
    }
    
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
            } else if let result = result?["results"] as? [[String:AnyObject]] {
                print(result)
                let locations = Student.studentLocationsFromResults(result)
                StudentData.sharedInstance.studentLocations = locations
                completionHandlerForStudentLocations(true, locations, nil)
            } else {
                print("JSON Parse Error")
                completionHandlerForStudentLocations(false, nil, ClientError.parseData.localizedDescription)
            }
        })
    }
    
    func postStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longitude: Double, _ completionhandlerForPOSTStudentLocation: @escaping clientSuccessCompletionHandler) {
        
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(userLocation.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(userLocation.lastName!)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = taskForPOSTMethod(Method.StudentLocation, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            if let error = error {
                completionhandlerForPOSTStudentLocation(false, NSError(domain: "POSTLocation error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an \(error)"]))
            } else {
                
                if let objectID = result?[JSONResponseKeys.ObjectID] as? String {
                    userLocation.objectId = objectID
                    completionhandlerForPOSTStudentLocation(true, nil)
                } else {
                    completionhandlerForPOSTStudentLocation(false, ClientError.parseData)
                }
            }
        })
    }
    
    func putStudentLocation(_ mapString: String, _ mediaURL: String, _ latitude: Double, _ longitude: Double, _ completionhandlerForPUTStudentLocation: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        let latitude = String(latitude)
        let longitude = String(longitude)
        
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(uniqueKey)\", \"\(JSONBodyKeys.FirstName)\": \"\(userLocation.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(userLocation.lastName!)\",\"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"\(JSONBodyKeys.Latitude)\": \(latitude), \"longitude\": \(longitude)}"
        
        let _ = taskForPUTMethod("\(Method.StudentLocation)"+"/\(userLocation.objectId!)", jsonBody, completionHandlerForPUT: {(result, error) in
            
            if let error = error {
                completionhandlerForPUTStudentLocation(false, ClientError.errorWith(description: error.localizedDescription))
            } else {
                if let objectID = result?[JSONResponseKeys.ObjectID] as? String {
                    userLocation.objectId = objectID
                    completionhandlerForPUTStudentLocation(true, nil)
                } else {
                    completionhandlerForPUTStudentLocation(false, ClientError.parseData)
                }
            }
        })
    }
}
