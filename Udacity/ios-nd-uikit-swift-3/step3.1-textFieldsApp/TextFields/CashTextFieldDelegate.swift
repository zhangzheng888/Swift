//
//  CashTextFieldDelegate.swift
//  TextFields
//
//  Created by kevin zhang on 7/20/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class CashTextFieldDelegate: NSObject, UITextFieldDelegate {

//    var numPennies = 0
//    
//    var strCents: String!
//    var strDollars: String!
//    var strMoney: String!
//    
//    func formatMoney() -> String {
//        let numCents = numPennies % 100
//        let numDollars = numPennies / 100 as NSNumber
//        
//        if numCents < 10 {
//            strCents = "0\(numCents)"
//        } else {
//            strCents = "\(numCents)"
//        }
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        strDollars = numberFormatter.string(from: numDollars)
//        strMoney = "$\(strDollars).\(strCents)"
//        return strMoney
//    }
    
    
    var amountTypedString = ""

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        guard let oldString:String = textField.text else {
//            return false
//        }
//        
//        let newString = oldString.replacingCharacters(in: range, with: string)
        
        
//        
//        let new = old.replacingCharacters( in: range, with: string );
//        
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 2
//        formatter.maximumFractionDigits = 2
//        formatter.numberStyle = .currency
//
//        var cents = 0
//        
//        //Strip out everything but digits
//        for character in new {
//            if let digit = String(character).toInt() {
//                cents = cents * 10 + digit
//            }
//        }
//        
//        //Convert int cents to NSNumber dollars
//        var dollars = NSNumber(value: Double(cents) / 100.0 as Double)
//        
//        //Format dollars
//        textField.text = formatter.string(from: dollars)
        
//        let newDigit: Int!
//        
//        //If backspace, recalculate
//        if (range.length == 1 && string.characters.count == 0) {
//            numPennies = numPennies / 10
//            textField.text = formatMoney()
//        }
//        
//        //If string is a digit, then multiply numPennies by 10 and add a new digit:
//        if Int(string) != nil {
//            newDigit = Int(string)
//            numPennies = (numPennies * 10 + newDigit)
//            textField.text = formatMoney()
//        }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        if string.characters.count > 0 {
            amountTypedString += string
            let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
            let newString = "$" + formatter.string(from: decNumber)!
            textField.text = newString
        } else {
            amountTypedString = String(amountTypedString.characters.dropLast())
            if amountTypedString.characters.count > 0 {
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                let newString = "$" + formatter.string(from: decNumber)!
                textField.text = newString
            } else {
                textField.text = ""
            }
        }
        return false
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        return true;
//    }
    
}
