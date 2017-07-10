//
//  ViewController.swift
//  Image Picker
//
//  Created by kevin zhang on 7/10/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func experiment(){
        let nextController = UIImagePickerController()
        self.present(nextController, animated: true, completion: nil)
    }

}

