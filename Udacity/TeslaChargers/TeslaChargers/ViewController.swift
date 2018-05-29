//
//  ViewController.swift
//  TeslaChargers
//
//  Created by Kevin Zhang on 5/26/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        API.shared.chargersService.getAllChargers { (collection) in
            if let c = collection {
                print("\n------------------")
                print("\n all resources total: ", c.chargers.count)
                c.chargers.forEach({
                    print("name: ", $0.name)
                    print("address: ", $0.address)
                })
                
                print("\n------------------")
                print("\nactive Resources total: ", c.activeResourcesOnly.count)
                c.activeResourcesOnly.forEach({
                    print("name: ", $0.name)
                    print("address: ", $0.address)
                })
                
                print("\n------------------")
                print("\n coming soon total: ", c.comingSoonChargers.count)
                c.comingSoonChargers.forEach({
                    print("name: ", $0.name)
                    print("address: ", $0.address)
                })
                print("\n------------------")
                
            } else {
                print("unable to get data at the moment")
            }
        }
    }
}

