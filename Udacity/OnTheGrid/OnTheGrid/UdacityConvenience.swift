//
//  UdacityConvenience.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/16/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

extension UdacityClient {
    
    // MARK: Authentication Methods
    
    func authenticateWithViewController(_ loginViewController: UIViewController, _ username: String, _ password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        postSession(username, password) { (success, error) in
            if success {
                completionHandlerForAuth(success, nil)
            } else {
                completionHandlerForAuth(success, "Error processing login")
            }
        }
    }
    
    func postSession(_ username: String, _ password: String, completionHandlerForSession: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = taskForPOSTMethod(Method.Session, jsonBody: jsonBody, completionHandlerForPOST: {(result, error) in
            
            if let error = error {
                completionHandlerForSession(false, NSError(domain: "postSession error", code: 1, userInfo: [NSLocalizedDescriptionKey: "The request to login returned the \(error)"]))
            } else {
                if let account = result?[ResponseKeys.account] as? [String:AnyObject], let userKey = account[ResponseKeys.key] as? String {
                    uniqueKey = userKey
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "The JSON parsing created an error"]))
                }
            }
        })
    }
    
    // MARK: Logout Methods
    
    func logoutFromApplication(completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let _ = taskForDELETEMethod(Method.Session, completionHandlerForDELETE: {(result, error) in
            
            if let error = error {
                completionHandlerForLogout(false, NSError(domain: "logoutSession Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            } else {
                completionHandlerForLogout(true, nil)
            }
        })
    }
    // MARK: Retrive User Data
    
    func getUdacityStudentData(completionHandlerForUdacityStudentData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let _ = taskForGETMethod("\(Method.Users)"+"/\(uniqueKey)", completionHandlerForGET: {(result, error) in
            if let error = error {
                completionHandlerForUdacityStudentData(false, NSError(domain: "getUdacityStudentData error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Your request returned an error: \(error)"]))
            }
            
            if let user = result?[ResponseKeys.user] as? [String:AnyObject], let firstName = user[ResponseKeys.firstName] as? String, let lastName = user[ResponseKeys.lastName] as? String {
                
                userLocation.firstName = firstName
                userLocation.lastName = lastName
                completionHandlerForUdacityStudentData(true, nil)
                
            } else {
                completionHandlerForUdacityStudentData(false, NSError(domain: "getUdacityStudentDat error", code: 1, userInfo: [NSLocalizedDescriptionKey: "You request returned an error: \(String(describing: error))"]))
            }
        })
    }
}
