//
//  AddLocationViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/25/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextfield.delegate = self
    }
    
    // MARK: Action
    
    @IBAction func cancelPressed(_ sender: Any){
        dismiss(animated: true, completion: nil )
    }
    
    @IBAction func findLocationPressed(_ sender: Any){
        userDidTapView(self)

        guard let text = locationTextfield.text, !text.isEmpty else {
            self.presentAlert("Error", "Location text field is empty", "OK")
            return
        }
        
        guard let findLocation: DetailedLocationViewController = storyboard?.instantiateViewController(withIdentifier: "DetailedLocationViewController") as? DetailedLocationViewController else {
            print("Detailed Location View Controller does not exist")
            return
        }
        findLocation.userLocationString = locationTextfield.text
        present(findLocation, animated: true, completion: nil)
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(locationTextfield)
    }
}

private extension AddLocationViewController {
    
    // MARK: Alert Controller
    
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Keyboard Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if locationTextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
