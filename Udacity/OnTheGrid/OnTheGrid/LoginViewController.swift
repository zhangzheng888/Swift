//
//  LoginViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/4/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var email: String?
    var password: String?
    
    // MARK: Outlets
    
    @IBOutlet weak var udacityImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Actions
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        userDidTapView(self)
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            
            email = usernameTextField.text!
            password = passwordTextField.text!
            
            UdacityClient.postSession(username: email!, password: password!) { (error: UdacityClient.RequestError?, errorDescription: String?) in
                
                if error == nil {
                    performUIUpdatesOnMain {
                        self.completeLogin()
                    }
                } else {
                    self.displayError(errorDescription)
                    
                }
            }
            
        }
        
    }
    
    // MARK: Sign Up
    @IBAction func signUpPressed() {
    
        userDidTapView(self)
        
        debugTextLabel.text = "Sign Up button pressed"
    }
    
    // MARK: Complete Login
    private func completeLogin() {
        debugTextLabel.text = ""
        let controller = storyboard?.instantiateViewController(withIdentifier: "MapNavigationalController") as! UITabBarController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
}
    
    // MARK: - LoginViewController (Configure UI)
    
private extension LoginViewController {
    
    func setUIEnabled(_ enabled: Bool) {
        usernameTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginButton.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
}

// MARK: - LoginViewController: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - LoginViewController (Keyboard Notifications)

private extension LoginViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if passwordTextField.isFirstResponder {
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

