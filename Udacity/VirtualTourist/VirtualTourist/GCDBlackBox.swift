//
//  GCDBlackBox.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 4/24/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
