//
//  hearthstone.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = Bundle.main.path(forResource: "hearthstone", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForHearthstoneJSON!))

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! JSONSerialization.jsonObject(with: rawHearthstoneJSON!, options: .allowFragments) as! NSDictionary

func parseJSONAsDictionary(_ dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    
    var minionCostOfFive = 0
    var weaponDurabilityOfTwo = 0
    var battlecryText = 0
    
    var numCostRatioItems = 0
    var sumCostRatio : Double = 0.0
    
    // Swift 3 Hashmap
    var numCostForRarityItemsDictionary = [String:Int]()
    var sumCostForRarityDictionary = [String:Int]()
    
    guard let hearthstoneDictionary = parsedHearthstoneJSON["Basic"] as? [[String:AnyObject]] else {
        print("the key basic can't be found")
        return
    }
    
    let rarities = ["Free", "Common"]
    
    // initialization...
    for rarity in rarities {
        numCostForRarityItemsDictionary[rarity] = 0
        sumCostForRarityDictionary[rarity] = 0
    }
    
    
    for eachCard in hearthstoneDictionary {
        
        guard let cardType = eachCard["type"] as? String else {
            print("the type key is invalid")
            return
        }
        
        if cardType == "Minion" {
            
            guard let attack = eachCard["attack"] as? Int else{
                print("the attack key is invalid")
                return
            }
            
            guard let mana = eachCard["cost"] as? Int else {
                print("the mana key is invalid")
                return
            }
            
            guard let rarityForCard = eachCard["rarity"] as? String else{
                print("the rarity key is invalid")
                return
            }
            
            numCostForRarityItemsDictionary[rarityForCard]! += 1
            sumCostForRarityDictionary[rarityForCard]! += mana
            
            if let text = eachCard["text"] as? String, text.range(of: "Battlecry") != nil {
                print("this minion has battlecry effect")
            }
            
            if mana == 5 {
                minionCostOfFive += 1
                print(minionCostOfFive)
            }
            
            if mana != 0 {
                
                numCostRatioItems += 1
                
                guard let health = eachCard["health"] as? Int else {
                    print("the health key is invalid")
                    return
                }
                
                sumCostRatio += (Double(attack) + Double(health)) / Double(mana)
            }
            
        }
        
        if cardType == "Weapon" {
            
            guard let durability = eachCard["durability"] as? Int else{
                print("the durability key is invalid")
                return
            }
            
            if durability == 2 {
                weaponDurabilityOfTwo += 1
                print(weaponDurabilityOfTwo)
            }
        }
    }
    
    // Calculate avg cost of minion base on rarity
    for rarity in rarities {
        print("\(rarity): \(Double(sumCostForRarityDictionary[rarity]!) / Double(numCostForRarityItemsDictionary[rarity]!))")
    }
    
    // Calculate the avg stat-to-cost ratio
    print("\(sumCostRatio/Double(numCostRatioItems))")
}

parseJSONAsDictionary(parsedHearthstoneJSON)
