//
//  Udacity.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/12/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    struct Constants {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let JsonApplication = "application/json"
    }
    
    struct Component {
        static let ApiScheme = "https"
        static let ApiHost = "udacity.com"
        static let ApiPath = "/api"
        static let SignUp = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
    }
    
    struct Method {
        static let StudentLocation = "/classes/StudentLocation"
        static let Session = "/session"
    }
    
    struct ParameterKeys {
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ApplicationID = "X-Parse-Application-Id"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let UniqueKey = "uniqueKey"
        
    }
    
    struct Header {
        static let ContentType = "Content-Type"
        static let Accept = "Accept"
    }
    
    struct ResponseKeys {
        static let account = "account"
        static let key = "key"
        static let session = "session"
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let status = "status"
        static let error = "error"
    }
    
}
