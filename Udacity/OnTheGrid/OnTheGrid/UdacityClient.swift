//
//  UdacityClient.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/13/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class UdacityClient: NSObject {
    
    // MARK: Shared Instance
    
    static let sharedInstance = UdacityClient()
    
    // MARK: Properties
    
    var session = URLSession.shared
    var email: String? = nil
    var password: String? = nil
    
    private override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(_ method: String, completionHandlerForGET: @escaping requestMethodCompletionHandler) -> URLSessionDataTask {
        var request = NSMutableURLRequest(url: udacityURLFromParameters(withPathExtension: method))
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        })
        
        task.resume()
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping requestMethodCompletionHandler) -> URLSessionDataTask {
        
        // 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.Accept)
        request.addValue(Constants.JsonApplication, forHTTPHeaderField: Header.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        // 4. Make the request */
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        // Start the request
        task.resume()
        return task
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod (_ method: String, completionHandlerForDELETE: @escaping requestMethodCompletionHandler) -> URLSessionTask {
        let request = NSMutableURLRequest(url: udacityURLFromParameters(withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        })
        
        // Start the request
        task.resume()
        return task
    }
    
    // MARK: Helpers
    // substitute the key for the value that is contained within the method name
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let range = Range(5..<data.count)
        let newData = data.subdata(in: range) /* subset response data! */
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // Create a URL from parameters
    
    private func udacityURLFromParameters(withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Component.ApiScheme
        components.host = Component.ApiHost
        components.path = Component.ApiPath + (withPathExtension ?? "")
        return components.url!
    }
}
