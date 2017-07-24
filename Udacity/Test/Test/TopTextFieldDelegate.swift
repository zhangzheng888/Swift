//
//  File.swift
//  Test
//
//  Created by kevin zhang on 7/22/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
