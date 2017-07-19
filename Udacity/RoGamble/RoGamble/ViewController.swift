//
//  ViewController.swift
//  RoGamble
//
//  Created by kevin zhang on 7/17/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit

enum Choice: Int {
    case Rock = 1, Paper, Scissors
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func rockPressed(sender: UIButton) {
        
        // Code Only
        let resultsViewController: ResultsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController") as! ResultsViewController
        
        resultsViewController.userChoice = Choice.Rock
        
        self.present(resultsViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func paperPressed(sender: UIButton) {
        // Code & Segue
        performSegue(withIdentifier: "paperSelected", sender: self)
    }
        //Segue Only
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let resultsViewController: ResultsViewController = segue.destination as! ResultsViewController
        
        if segue.identifier == "scissorsSelected" {
            resultsViewController.userChoice = Choice.Scissors
        }
        else if segue.identifier == "paperSelected" {
            resultsViewController.userChoice = Choice.Paper
        }
    }
}

