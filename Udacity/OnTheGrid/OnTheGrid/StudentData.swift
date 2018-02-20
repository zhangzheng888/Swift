//
//  StudentData.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/15/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

struct StudentData{
    
    static var sharedInstance = StudentData()
    
    // MARK: - Properties
    
    var students = [Student]()
    
    private init() {}
}
