//
//  HTTP.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/26/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]
public typealias QueryParams = [String: String]

public struct HTTPResponse {
    let statusCode: Int?
    let rawData: Data?
    let jsonData: JSON?
    let error: Error?
    
    init(statusCode: Int?, data: Data?, jsonData: JSON?, error: Error?) {
        self.statusCode = statusCode
        self.rawData = data
        self.jsonData = jsonData
        self.error = error
    }
}

public struct HTTP {
    public enum MethodType: String {
        case POST
        case GET
    }
    
    fileprivate var defaultSession: URLSession
    let contentType: String = "application/json"
    let apiEndpoint: String
    
    public init(endpoint: String, sessionConfiguration: URLSessionConfiguration) {
        self.apiEndpoint = endpoint
        self.defaultSession = URLSession(configuration: sessionConfiguration)
    }
    
    public func prepareRequest(route: String, method: MethodType, queryParams: [String: String]? = nil, body: JSON? = nil) -> NSMutableURLRequest {
        let urlPath: String = apiEndpoint.appending(route)
        
        var urlComponents = URLComponents(string: urlPath)
        if let query = queryParams {
            urlComponents?.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        }
        
        let request = NSMutableURLRequest(url: urlComponents!.url!)
        request.httpMethod = method.rawValue
        request.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder.encodeToData(json: body)
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            } catch {
                debugPrint("ERROR: failed to encode json", error.localizedDescription)
            }
        }
        return request
    }
    
    public func makeRequest(request: NSMutableURLRequest, completionHandler:@escaping (_ response: HTTPResponse) -> Void) {
        let task = defaultSession.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            
            let responseStatusCode: Int? = (response as? HTTPURLResponse)?.statusCode
            
            if let data = data {
                do {
                    let jsonData = try JSONDecoder.parse(data: data)
                    let respo = HTTPResponse(statusCode: responseStatusCode, data: data, jsonData: jsonData, error: nil)
                    completionHandler(respo)
                }
                catch {
                    debugPrint("ERROR: failed to decode json", error.localizedDescription)
                    let respo = HTTPResponse(statusCode: responseStatusCode, data: data, jsonData: nil, error: error)
                    completionHandler(respo)
                }
            } else {
                let respo = HTTPResponse(statusCode: responseStatusCode, data: data, jsonData: nil, error: error)
                completionHandler(respo)
            }
        }
        task.resume()
    }
}
