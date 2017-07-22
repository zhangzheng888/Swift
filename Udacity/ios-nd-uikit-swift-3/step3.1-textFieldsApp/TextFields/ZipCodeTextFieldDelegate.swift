//
//  ZipCodeTextFieldDelegate.swift
//  TextFields
//
//  Created by kevin zhang on 7/20/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit


class ZipCodeTextFieldDelegate: NSObject, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // textField.text is always 1 character short of user input, so create new string newText that takes into account most recent user input character
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        let match = newText.range(of:"^\\d{0,5}$", options: .regularExpression)
        
        // this method, as written, creates a new string that replaces the last character (empty) at the end with the character that was just entered into the textField
        print("string is \(string)")
        print("newText is \(newText)")
        print("textField text is \(textField.text)")
        
        return match.location == 0//newText.length <= 5
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
