//
//  ViewController.swift
//  ImageRequest
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // URL creation
        let imageURL = URL(string: Constants.AMGURL)!
        
        // use "URLSession.shared" to access the shared URLSession, network request
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            
            if error == nil {
                // create image
                let downloadImage = UIImage(data: data!)
                
                //code above is executed in the background. black box method which performs updates on main
                
                performUIUpdatesOnMain {
                    self.imageView.image = downloadImage
                }
            } else {
                print("there was an error in the request!")
            }
        }
        // starts network request
        task.resume()
    }
}
