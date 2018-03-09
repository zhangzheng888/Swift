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
    func getStudentLocation(uniqueKey: String, completion: @escaping (_ student: Student?, _ error: NSError?) -> Void) {
        
        let parameters = [ParameterKeys.Where: "{\"\(ParameterKeys.UniqueKey)\":\"" + "\(uniqueKey)" + "\"}" as AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters as [String:AnyObject]) { (data: AnyObject?, error: NSError?) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let result = data!["results"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(result)
            
            let studentDictionary = result[0]
            let location = Location(dictionary: studentDictionary)
            let student = Student(dictionary: studentDictionary, location: location)
            
            completion(student, nil)
        }
    }

    func getStudentsLocation(completion: @escaping (_ students: [Student]?, _ error: NSError?) -> Void) {
        
        let parameters = ["limit": "100", "order": "-updatedAt"] as [String: AnyObject]
        
        let _ = taskForGETMethod(Method.StudentLocation, parameters: parameters as [String:AnyObject]) { (data: AnyObject?, error: NSError?) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let results = data!["results"] as? [[String : AnyObject]] else {
                sendError("No data was returned by the request!")
                return
            }
            
            var students: [Student] = []
            
            for result in results {
                
                let location = Location(dictionary: result)
                
                if location.coordinate != nil {
                    
                    let student = Student(dictionary: result, location: location)
                    
                    let firsNameHasEmptyString = student.firstName == nil || student.firstName == ""
                    
                    let lastNameHasEmptyString = student.lastName == nil || student.lastName == ""
                    
                    if !firsNameHasEmptyString || !lastNameHasEmptyString {
                        
                        students.append(student)
                        
                    } else {
                        // Handle no name student error here
                        sendError("No Student Name returned")
                        return
                    }
                    
                } else {
                    // Handle no location student error here
                    sendError("No Student Location returned")
                    return
                    
                }
            }
            
            StudentData.sharedInstance.students = students
            
            completion(students, nil)
            
        }
    }
}
