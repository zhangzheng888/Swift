//
//  LoginViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 2/4/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    
    var appDelegate: AppDelegate!
    var reachability = Reachability()!
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
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugTextLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkAvailable()
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: Login
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        userDidTapView(self)
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Username or Password Empty."
            presentAlert("Error", "Username or Password Empty.", "Dismiss")
        } else {
            email = usernameTextField.text!
            password = passwordTextField.text!
            UdacityClient.sharedInstance.authenticateWithViewController(self, email!, password!) { (success, error) in
            performUIUpdatesOnMain {
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(error)
                        self.presentAlert("Login Error", "Please check your login credentials", "Try Again")
                    }
                }
            }
        }
    }
    
    // MARK: Sign Up
    
    @IBAction func signUpPressed() {
        guard let link = URL(string:UdacityClient.Component.SignUp) else {
            debugTextLabel.text = "Invalid Sign-Up Link"
            return
        }
        UIApplication.shared.open(link)
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

extension UIViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

private extension LoginViewController {
    
    func displayError(_ errorString: String?) {
        if let errorString = errorString {
            performUIUpdatesOnMain() {
                self.debugTextLabel.text = errorString
            }
        }
    }
    
    // MARK: Alert Controller
    
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Network Availability
    
    func networkAvailable() {
        reachability.whenReachable = { _ in
            print("Network reachable")
        }
        
        reachability.whenUnreachable = { _ in
            self.presentAlert("Network Error", "There is a problem with network connectivity", "OK")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
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

