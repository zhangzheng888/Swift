//
//  ViewController.swift
//  RoGamble
//
//  Created by kevin zhang on 7/17/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

//enum Choice: Int {
//    case Rock = 1, Paper, Scissors
//}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func randomRoshamboValue() -> Int {
        // Generate a random Int32 using arc4Random
        let randomValue = 1 + arc4random() % 3
        
        // Return a more convenient Int, initialized with the random value
        return Int(randomValue)
    }
    
    @IBAction func rockPressed(sender: UIButton) {
        
        // Code Only
        let resultsViewController: ResultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        
//        resultsViewController.userChoice = Choice.Rock
        resultsViewController.myHand = 1
        resultsViewController.opponentHand = randomRoshamboValue()
        
        self.present(resultsViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func paperPressed(sender: UIButton) {
        // Code & Segue
        performSegue(withIdentifier: "paperSelected", sender: self)
    }
    
        //Segue Only
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scissorsSelected" {
            let resultsViewController = segue.destination as! ResultsViewController
//            resultsViewController.userChoice = Choice.Scissors
            resultsViewController.myHand = 3
            resultsViewController.opponentHand = randomRoshamboValue()

        } else {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.myHand = 2
            resultsViewController.opponentHand = randomRoshamboValue()

        }
        
//        let resultsViewController: ResultsViewController = segue.destination as! ResultsViewController
//        
//        if segue.identifier == "scissorsSelected" {
//            resultsViewController.userChoice = Choice.Scissors
//        }
//        else if segue.identifier == "paperSelected" {
//            resultsViewController.userChoice = Choice.Paper
//        }
    }
}

