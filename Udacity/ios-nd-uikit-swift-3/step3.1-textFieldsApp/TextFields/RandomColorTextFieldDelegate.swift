//
//  RandomColorTextFieldDelegate.swift
//  TextFields
//
//  Created by kevin zhang on 7/20/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ColorizerTextFieldDelegate: NSObject, UITextFieldDelegate

class RandomColorTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // MARK: Properties
    
    let colors: [UIColor] = [
        .red,
        .orange,
        .yellow,
        .green,
        .blue,
        .brown,
        .black,
        .purple,
        .cyan,
        .magenta,
        .white
    ]
    
    func randomColor() -> UIColor {
    
        let randomIndex = Int(arc4random() % UInt32(colors.count))
        
        return colors[randomIndex]
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            textField.textColor = randomColor()
            return true
    }
}
