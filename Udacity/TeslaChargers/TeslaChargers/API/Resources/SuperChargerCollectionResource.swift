//
//  SuperChargerCollectionResource.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/28/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

class SuperChargerCollectionResource {
    let offset: Int?
    let total: Int?
    let chargers: [SuperChargerResource]
    
    init(json: JSON) {
        offset = json["offset"] as? Int
        total = json["total_rows"] as? Int
        
        let data = json["rows"] as? [JSON] ?? []
        chargers = data.compactMap { SuperChargerResource(json: $0) }
    }
    
    var comingSoonChargers: [SuperChargerResource] {
        return chargers.filter { return $0.active == false }
    }
    
    var activeResourcesOnly: [SuperChargerResource] {
        return chargers.filter { return $0.active }
    }
}
