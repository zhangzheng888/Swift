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

struct HTTPResponse {
    let statusCode: Int
    let data: Data?
    let error: Error?
    
    init(statusCode: Int, data: Data?, error: Error?) {
        self.statusCode = statusCode
        self.data = data
        self.error = error
    }
}

struct HTTP {
    enum MethodType: String {
        case POST
        case GET
    }
    
    fileprivate var defaultSession: URLSession
    let contentType: String = "application/json"
    let apiEndpoint: String
    
    init(endpoint: String, sessionConfiguration: URLSessionConfiguration) {
        self.apiEndpoint = endpoint
        self.defaultSession = URLSession(configuration: sessionConfiguration)
    }
    
    func prepareRequest(route: String, method: MethodType, queryParams: [String: String]? = nil, body: JSON? = nil) -> NSMutableURLRequest {
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
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
            } catch {
                debugPrint("ERROR: failed to encode json")
            }
        }
        return request
    }
    
    func makeRequest(request: NSMutableURLRequest, completionHandler:(_ response: HTTPResponse) -> Void) {
        let task = defaultSession.dataTask(with: request as URLRequest) { (data:Data?, response:URLResponse?, error:Error?) in
//            if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, let data:Data = data {
//                do {
//                    let json = try JSONDecoder.parse(data: data)
//                    let response = HTTPResponse(statusCode: httpResponse.statusCode, json: json, data: data)
//                    completion(response)
//                }
//                catch {
//                    let response = HTTPResponse(statusCode: httpResponse.statusCode, json: nil, data: data)
//                    completion(response)
//                }
//            }
//            else {
//                let response = HTTPResponse(statusCode: 0, json: nil, data: data)
//                completion(response)
//            }
        }
        task.resume()
    }
}
