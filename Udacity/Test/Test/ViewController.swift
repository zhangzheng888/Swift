//
//  ViewController.swift
//  Test
//
//  Created by kevin zhang on 7/22/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // MARK: - UI
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - Properties
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber (value: -4.0)]
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    func saveMemeImage(generatedImage: UIImage) {
        // Create the meme
        let meme = MemeImage(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memeImage: generatedImage)
    }
    
    func generateMemeImage() -> UIImage {
        
        topToolBar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let generatedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolBar.isHidden = false
        bottomToolbar.isHidden = false
        
        return generatedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Image Picker Action
    
//    @IBAction func imagePicker(_ sender: Any) {
//        let pickerController = UIImagePickerController()
//        present(pickerController, animated: true, completion: nil)
//    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareImage(_ sender: Any) {
    
        let sharedImage = generateMemeImage()
        let controller = UIActivityViewController( activityItems: [sharedImage], applicationActivities: nil )
        self.present(controller, animated: true, completion: nil)
        
        controller.completionWithItemsHandler = {
                activityType, completion, items, error in
                
                if completion {
                    // Save meme
                    
                    self.saveMemeImage(generatedImage: sharedImage)
                    
                } else {
                    
                }
                
                self.dismiss( animated: true, completion: nil )
        }

    }
    
    // MARK: - Image Picker Protocols
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        } else {
            //TODO:
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Keyboard Appearance
    func keyboardWillShow(_ notification:Notification) {
        
//        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Keyboard Notification
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
}

