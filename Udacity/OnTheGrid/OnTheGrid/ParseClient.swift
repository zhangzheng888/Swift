//
//  ParseClient.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/4/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    
    // MARK: Shared Instance
    static var sharedInstance = ParseClient()
    
    // MARK: Properties
    var session = URLSession.shared
    
    typealias requestCompletionHandler = (_ result: AnyObject?, _ error:NSError?) -> Void
    var locations: [[String:AnyObject]]? = nil
    
    // MARK: Initialization

    private override init() {
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(_ method: String,  parameters: [String:AnyObject], completionHandlerForGET: @escaping requestCompletionHandler) -> URLSessionDataTask {
        
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
    
    func taskForPUTMethod(_ method: String, _ jsonBody: String, completionHandlerForPUT: @escaping requestCompletionHandler) ->
        URLSessionTask {
            let request = NSMutableURLRequest(url: parseURLFromParameters(withPathExtension: method))
            request.httpMethod = "PUT"
            request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
            request.addValue(Constants.APIKey, forHTTPHeaderField: ParameterKeys.APIKey)
            request.addValue(Constants.JSONApplication, forHTTPHeaderField: ParameterKeys.ContentType)
            request.httpBody = jsonBody.data(using: .utf8)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                func sendError(_ error: String){
                    print(error)
                    let userInfo = [NSLocalizedDescriptionKey: error]
                    completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
                }
                
                guard (error==nil) else {
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
                
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
            })
            
            task.resume()
            return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping requestCompletionHandler) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: self.parseURLFromParameters(parameters: nil, withPathExtension: method))
        
        request.httpMethod = "POST"
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: ParameterKeys.ApplicationID)
        request.addValue(Constants.APIKey, forHTTPHeaderField: ParameterKeys.APIKey)
        request.addValue(Constants.JSONApplication, forHTTPHeaderField: ParameterKeys.ContentType)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
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
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        return task
    }
    
    // MARK: HELPERS
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: requestCompletionHandler) {
        
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
    
    private func parseURLFromParameters(withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = ParseClient.Constants.APIScheme
        components.host = ParseClient.Constants.APIHost
        components.path = ParseClient.Constants.APIPath + "/" + (withPathExtension ?? "")
        return components.url!
    }
}
