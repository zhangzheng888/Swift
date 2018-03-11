//
//  ParseClient.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/4/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    var session = URLSession.shared
    
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    
    // MARK: Initialization
    
    override init() {
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(_ method: String,  parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error:NSError?) -> Void) -> URLSessionDataTask {
        
        let url = self.parseURLFromParameters(parameters: parameters, withPathExtension: method)
        
        let request = NSMutableURLRequest(url: url)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constants.APIKey, forHTTPHeaderField: ParameterKeys.APIKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        return task
    }
    
    // MARK: PUT
    
    // MARK: POST
    func taskForWriteMethod(_ method: String, httpMethod: Write, jsonBody: String, completionHandlerForWrite: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: self.parseURLFromParameters(parameters: nil, withPathExtension: method))
        
        request.httpMethod = httpMethod.rawValue
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constants.APIKey, forHTTPHeaderField: ParameterKeys.APIKey)
        request.addValue(Constants.JSONApplication, forHTTPHeaderField: ParameterKeys.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForWrite(nil, NSError(domain: "taskForWriteMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForWrite)
        }
        
        task.resume()
        return task
    }
    
    // MARK: HELPERS
    
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
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func parseURLFromParameters(parameters: [String:AnyObject]?, withPathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.APIScheme
        components.host = ParseClient.Constants.APIHost
        components.path = ParseClient.Constants.APIPath + "/" + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters! {
            
            guard parameters != nil else {                
                return components.url!
            }
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
