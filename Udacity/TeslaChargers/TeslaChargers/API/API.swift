//
//  API.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/26/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

public struct API {
    static let shared = API()
    
    // MARK: - Properties
    private let http: HTTP
    let chargersService: ChargersService
    
    // MARK: - Lifecycle
    private init() {
        let session = URLSessionConfiguration.default
      
        let cloudantAccount = "05291d31-bb22-4426-b078-320bb4dc6060-bluemix"
        let cloudantApiKey = "outherearysshaterrytorti"
        let cloudantApiPassword = "7a7129bf174b5bc0f771c98fab9dc0f599bba71e"
        
        let credentials = "\(cloudantApiKey):\(cloudantApiPassword)"
        let host = "\(cloudantAccount).cloudant.com"
        let apiAddress = "https://\(credentials)@\(host)/"
        
        /*
        Key:outherearysshaterrytorti
        Password:7a7129bf174b5bc0f771c98fab9dc0f599bba71e
        */
        http = HTTP(endpoint: apiAddress, sessionConfiguration: session)
        chargersService = ChargersService(http: http)
    }
}
