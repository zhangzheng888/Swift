//
//  ViewController.swift
//  TextFields
//
//  Created by Jason on 11/11/14.
//  Copyright (c) 2014 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController, UITextFieldDelegate

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField7: UITextField!
    @IBOutlet weak var enableTextField: UISwitch!
    
    // Variables
    var timer: Timer!
    
    // MARK: Text Field Delegate objects
    let emojiDelegate = EmojiTextFieldDelegate()
    let colorizerDelegate = ColorizerTextFieldDelegate()
    let randomcolorDelegate = RandomColorTextFieldDelegate()
    let zipcodeDelegate = ZipCodeTextFieldDelegate()
    let cashDelegate = CashTextFieldDelegate()
//    let lockableDelegate = LockableTextFieldDelegate(lockSwitch: UISwitch)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // set the label to be hidden
        self.characterCountLabel.isHidden = true
        
        // Set the three delegates
        self.textField1.delegate = emojiDelegate
        self.textField2.delegate = randomcolorDelegate
        self.textField3.delegate = self
        self.textField4.delegate = colorizerDelegate
        self.textField5.delegate = zipcodeDelegate
        self.textField6.delegate = cashDelegate
        self.textField7.delegate = self
    }
    
    // MARK: Text Field Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Figure out what the new text will be, if we return true
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        // hide the label if the newText will be an empty string
        self.characterCountLabel.isHidden = (newText.length == 0)
        
        // Write the length of newText into the label
        self.characterCountLabel.text = String(newText.length)
        
        let randomColor = UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1.0)
        self.view.backgroundColor = randomColor
        
        // returning true gives the text field permission to change its text
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        stopTimer()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        
        startTimer()
        
    }
    
    func updateBackgroundColor() {
        
        let randomColor = UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1.0)
        
        self.view.backgroundColor = randomColor
        
    }
    
    func startTimer() {
        // Stop any (already) existing timer
        if timer != nil {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.updateBackgroundColor), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        // Stop any (already) existing timer
        if timer != nil {
            timer.invalidate()
        }
        
    }
    @IBAction func switchToggled(sender: UISwitch) {
        textField7.isEnabled = sender.isOn
    }
    
}

