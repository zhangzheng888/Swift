//
//  ResultsViewController.swift
//  RoGamble
//
//  Created by kevin zhang on 7/17/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var resultsImageView: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    var userChoice: Choice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let random = randomRoshamboValue()
        let computerChoice: Choice! = Choice(rawValue: random)
        let kevin = userChoice
        // Compare the user choice with the AI
        if userChoice == computerChoice {
            resultsLabel.text = "It's a Tie!"
            resultsImageView.image = UIImage(named: "itsATie")
        }
        else if userChoice == .Paper && computerChoice == .Rock {
            resultsLabel.text = "You Win!"
            resultsImageView.image = UIImage(named: "PaperCoversRock")
        }
        else if userChoice == .Paper && computerChoice == .Scissors {
            resultsLabel.text = "You Lose!"
            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
        }
        else if userChoice == .Rock && computerChoice == .Scissors {
            resultsLabel.text = "You Win!"
            resultsImageView.image = UIImage(named: "RockCrushesScissors")
        }
        else if userChoice == .Rock && computerChoice == .Paper {
            resultsLabel.text = "You Lose!"
            resultsImageView.image = UIImage(named: "PaperCoversRock")
        }
        else if userChoice == .Scissors && computerChoice == .Paper {
            resultsLabel.text = "You Win!"
            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
        }
        else if userChoice == .Scissors && computerChoice == .Rock {
            resultsLabel.text = "You Lost!"
            resultsImageView.image = UIImage(named: "RockCrushesScissors")
        }
    }
    
    func randomRoshamboValue() -> Int {
        // Generate a random Int32 using arc4Random
        let randomValue = 1 + arc4random() % 3
        
        // Return a more convenient Int, initialized with the random value
        return Int(randomValue)
    }
    
    
    @IBAction func tryAgainPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
