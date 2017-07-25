//
//  BottomTextFieldDelegate.swift
//  MemeU 1.0
//
//  Created by kevin zhang on 7/24/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
