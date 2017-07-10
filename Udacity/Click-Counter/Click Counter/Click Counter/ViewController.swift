//
//  ViewController.swift
//  Click Counter
//
//  Created by kevin zhang on 7/9/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 0
    var count2 = 0
    var label:UILabel!
    var label2:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK: UI Properties
        var label = UILabel()
        label.frame = CGRect.init(x: 150, y: 150, width: 60, height: 60)
        label.text = "0"
        self.view.addSubview(label)
        self.label = label
        
        var label2 = UILabel()
        label2.frame = CGRect.init(x: 180, y: 180, width: 60, height: 60)
        label2.text = "0"
        self.view.addSubview(label2)
        self.label2 = label2
        
        var button = UIButton()
        button.frame = CGRect.init(x: 150, y: 250, width: 60, height: 60)
        button.setTitle("Click to +", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(ViewController.incrementCount), for: UIControlEvents.touchUpInside)
        
        var button2 = UIButton()
        button2.frame = CGRect.init(x: 210, y: 300, width: 60, height: 60)
        button2.setTitle("Click to -", for: .normal)
        button2.setTitleColor(UIColor.red, for: .normal)
        self.view.addSubview(button2)
        
        button2.addTarget(self, action: #selector(ViewController.decrementCount), for: UIControlEvents.touchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Incrementation
    func incrementCount() {
        self.count += 1
        self.count2 += 1
        self.label.text = "\(self.count)"
        self.label2.text = "\(self.count2)"
    }
    //MARK: Decrementation
    func decrementCount() {
        self.count -= 1
        self.count2 -= 1
        self.label.text = "\(self.count)"
        self.label2.text = "\(self.count2)"
    }

}
