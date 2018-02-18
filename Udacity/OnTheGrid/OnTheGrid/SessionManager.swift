//
//  SessionManager.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/17/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

class SessionManager: NSObject {
    
    static var session: Session? = nil
    
    struct Session {
        var id: String
        var expiration: String
        var key: String
        
        init(id: String, key: String, expiration: String) {
            self.id = id
            self.key = key
            self.expiration = expiration
        }
    }
    
}
