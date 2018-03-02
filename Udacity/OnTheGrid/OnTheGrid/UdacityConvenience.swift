//
//  UdacityConvenience.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/16/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
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
                if let account = result?[ResponseKeys.account] as? [String:AnyObject], let uniqueKey = account[ResponseKeys.key] as? String {
                    userKey = uniqueKey
                    completionHandlerForSession(true, nil)
                } else {
                    completionHandlerForSession(false, NSError(domain: "postSession parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "The JSON parsing created an error"]))
                }
            }
        })
    }
    
    
}
