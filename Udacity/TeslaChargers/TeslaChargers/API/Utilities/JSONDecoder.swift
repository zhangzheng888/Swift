//
//  JSONDecoder.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/28/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

enum JSONDecoderError: String, Error {
    case parseError  = "Unable to Parse JSON"
}

public struct JSONDecoder {
    static func parse(data: Data) throws -> JSON {
        do {
            let jsonDict: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let result = jsonDict as? JSON else { throw JSONDecoderError.parseError }
            return result
        } catch {
            throw JSONDecoderError.parseError
        }
    }
}

