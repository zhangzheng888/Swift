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
    
    private init() {}
    
    // MARK: - Properties
    
    private var students = [Student]()
}
