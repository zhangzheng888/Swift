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
    
    var myHand : Int?
    var opponentHand : Int?
    
    
    override func viewWillAppear(animated: Bool) {
        // Determine what image and message to display
        let play = (myHand!, opponentHand!)
        switch play {
        case (1,1):
            resultImage.image = UIImage(named: "Tie")
            messageLabel.text = "It's a tie! We both have rocks."
        case (1,2):
            resultImage.image = UIImage(named:"PaperCoversRock")
            messageLabel.text = "I won! My paper covers your rock."
        case (1,3):
            resultImage.image = UIImage(named:"RockCrushesScissors")
            messageLabel.text = "You won! Your rock crushes my scissors."
        case (2,1):
            resultImage.image = UIImage(named:"PaperCoversRock")
            messageLabel.text = "You won! Your paper covers my rock."
        case (2,2):
            resultImage.image = UIImage(named: "Tie")
            messageLabel.text = "It's a tie! We both have papers."
        case (2,3):
            resultImage.image = UIImage(named: "ScissorsCutPaper")
            messageLabel.text = "I won! My scissors cut your paper."
        case (3,1):
            resultImage.image = UIImage(named: "RockCrushesScissors")
            messageLabel.text = "You lose! My rock crushes your scissors."
        case (3,2):
            resultImage.image = UIImage(named: "ScissorsCutPaper")
            messageLabel.text = "You won! Your scissors cut my paper."
        case (3,3):
            resultImage.image = UIImage(named: "Tie")
            messageLabel.text = "It's a tie! We both have scissors."
        default:
            resultImage.image = nil
            messageLabel.text = "..."
        }
    }
    
}
