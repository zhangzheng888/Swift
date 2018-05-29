//
//  JSONEncoder.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/28/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

enum JSONEncoderError: String, Error {
    case invalidJSON = "Invalid JSON"
    case parseError  = "Unable to Parse JSON"
}

public struct JSONEncoder {
    static func encodeToData(json: JSON) throws -> Data {
        if JSONSerialization.isValidJSONObject(json) {
            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: json, options: [])            
                return jsonData
            } catch {
                throw JSONEncoderError.parseError
            }
        } else {
            throw JSONEncoderError.invalidJSON
        }
    }
}
