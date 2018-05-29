//
//  SuperChargerResource.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/28/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

class SuperChargerResource {
    let identifier: String
    
    let name: String
    let street: String
    let city: String
    let state: String
    let zipcode: String
    let updated: String
    let active: Bool
    
    var address: String {
        return "\(street) \(city), \(state) \(zipcode)"
    }
    
    init?(json: JSON) {
        guard let document = json["doc"] as? JSON else { return nil }
        guard let id = document["_id"] as? String, id.isEmpty == false else { return nil }
        
        identifier = id
        name = document["name"] as? String ?? ""
        street = document["street"] as? String ?? ""
        city = document["city"] as? String ?? ""
        state = document["state"] as? String ?? ""
        zipcode = document["zipcode"] as? String ?? ""
        updated = document["updated"] as? String ?? ""
        active = document["active"] as? Bool ?? false
    }
}
