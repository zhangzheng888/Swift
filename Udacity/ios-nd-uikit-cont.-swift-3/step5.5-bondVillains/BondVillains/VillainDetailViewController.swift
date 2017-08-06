//
//  VillainDetailViewController.swift
//  BondVillains
//
//  Created by kevin zhang on 8/6/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit


class VillainDetailViewController: UIViewController {
    // MARK: Properties
    
    var villain: Villain!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.label.text = self.villain.name
        self.imageView!.image = UIImage(named: villain.imageName)
    }
}
 
