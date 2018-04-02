//
//  ParseConstants.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/11/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
     
        // MARK: APP ID
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: API Key
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URL
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse"
        
        // MARK: Content Type
        static let JSONApplication = "application/json"
        
    }
    
    // MARK: Method
    struct Method {
        
        static let StudentLocation = "/classes/StudentLocation"
    
    }
    
    // MARK: JSONBodyKeys
    struct JSONBodyKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
    }
    
    // MARK: JSONResponseKeys
    struct JSONResponseKeys {
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let MapString = "mapString"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        static let APIKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let UniqueKey = "uniqueKey"
        static let ContentType = "Content-Type"
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        
    }
    
    struct ParameterValues {
        
        static let LimitValue = "100"
        static let LatestOrderValue = "-updatedAt"
        static let UniqueKey = "uniqueKey"
        
    }
}
