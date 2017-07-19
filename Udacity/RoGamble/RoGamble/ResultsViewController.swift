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
    
//    var userChoice: Choice?
    
    var myHand : Int?
    var opponentHand : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let random = randomRoshamboValue()
//        let computerChoice: Choice! = Choice(rawValue: random)
//        let kevin = userChoice
//        
//        // Compare the user choice with the AI
//        if userChoice == computerChoice {
//            resultsLabel.text = "It's a Tie!"
//            resultsImageView.image = UIImage(named: "itsATie")
//        }
//        else if userChoice == .Paper && computerChoice == .Rock {
//            resultsLabel.text = "You Win!"
//            resultsImageView.image = UIImage(named: "PaperCoversRock")
//        }
//        else if userChoice == .Paper && computerChoice == .Scissors {
//            resultsLabel.text = "You Lose!"
//            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
//        }
//        else if userChoice == .Rock && computerChoice == .Scissors {
//            resultsLabel.text = "You Win!"
//            resultsImageView.image = UIImage(named: "RockCrushesScissors")
//        }
//        else if userChoice == .Rock && computerChoice == .Paper {
//            resultsLabel.text = "You Lose!"
//            resultsImageView.image = UIImage(named: "PaperCoversRock")
//        }
//        else if userChoice == .Scissors && computerChoice == .Paper {
//            resultsLabel.text = "You Win!"
//            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
//        }
//        else if userChoice == .Scissors && computerChoice == .Rock {
//            resultsLabel.text = "You Lost!"
//            resultsImageView.image = UIImage(named: "RockCrushesScissors")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Determine what image and message to display
        
        let play = (myHand!, opponentHand!)
        let kevin = myHand
        switch play {
        case (1,1):
            resultsImageView.image = UIImage(named: "ItsATie")
            resultsLabel.text = "It's a tie! We both have rocks."
        case (1,2):
            resultsImageView.image = UIImage(named:"PaperCoversRock")
            resultsLabel.text = "I won! My paper covers your rock."
        case (1,3):
            resultsImageView.image = UIImage(named:"RockCrushesScissors")
            resultsLabel.text = "You won! Your rock crushes my scissors."
        case (2,1):
            resultsImageView.image = UIImage(named:"PaperCoversRock")
            resultsLabel.text = "You won! Your paper covers my rock."
        case (2,2):
            resultsImageView.image = UIImage(named: "ItsATie")
            resultsLabel.text = "It's a tie! We both have papers."
        case (2,3):
            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
            resultsLabel.text = "I won! My scissors cut your paper."
        case (3,1):
            resultsImageView.image = UIImage(named: "RockCrushesScissors")
            resultsLabel.text = "You lose! My rock crushes your scissors."
        case (3,2):
            resultsImageView.image = UIImage(named: "ScissorsCutPaper")
            resultsLabel.text = "You won! Your scissors cut my paper."
        case (3,3):
            resultsImageView.image = UIImage(named: "ItsATie")
            resultsLabel.text = "It's a tie! We both have scissors."
        default:
            resultsImageView.image = nil
            resultsLabel.text = "..."
        }
    }
    
//    func randomRoshamboValue() -> Int {
//        // Generate a random Int32 using arc4Random
//        let randomValue = 1 + arc4random() % 3
//        
//        // Return a more convenient Int, initialized with the random value
//        return Int(randomValue)
//    }
    
    
    @IBAction func tryAgainPressed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
