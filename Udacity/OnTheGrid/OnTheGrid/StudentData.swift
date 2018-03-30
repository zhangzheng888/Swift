//
//  StudentData.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/15/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

public var uniqueKey: String = ""

var userLocation = Student(dictionary: [:])

class StudentData{
    
    static let sharedInstance = StudentData()
    
    // MARK: - Properties
    
    var studentLocations = [Student]()
    
    private init() {}
}
