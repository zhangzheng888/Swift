//
//  GCD.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/18/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
