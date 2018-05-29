//
//  ChargersService.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/28/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

struct ChargersService {
    let baseRoute = "chargers"
    
    var http: HTTP
    
    // MARK: - Lifecycle
    init(http: HTTP) {
        self.http = http
    }
    
    // MARK: - Requests
    public func getAllChargers(completion: @escaping (_ resources: SuperChargerCollectionResource?) -> Void){
        let route = "\(baseRoute)/_all_docs"
        let params = ["include_docs":"true"]
        
        let request = self.http.prepareRequest(route: route, method: .GET, queryParams: params, body: nil)
        http.makeRequest(request: request) { (response: HTTPResponse) in
            var collection:SuperChargerCollectionResource?
            if let jsonData = response.jsonData {
                collection = SuperChargerCollectionResource(json: jsonData)
            }
            completion(collection)
        }
    }
    
    private func bodyPayload() -> JSON {
        var params = [String: Any]()
        
        //any valid id
        params["selector"] = [
            "_id":[ "$gt": "0"]
        ]
        
        params["fields"] = ["_id", "_rev", "name", "street", "city", "state", "zipcode", "updated", "active"]
        return params
    }
}
