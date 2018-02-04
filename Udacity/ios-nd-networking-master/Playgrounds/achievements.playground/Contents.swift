//
//  achievements.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAchievementsJSON = Bundle.main.path(forResource: "achievements", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAchievementsJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForAchievementsJSON!))

/* Error object */
var parsingAchivementsError: NSError? = nil

/* Parse the data into usable form */
var parsedAchievementsJSON = try! JSONSerialization.jsonObject(with: rawAchievementsJSON!, options: .allowFragments) as! NSDictionary

func parseJSONAsDictionary(_ dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    
    var cardsGreaterThan10 = 0
    
    var numAchievements = 0
    var sumAchievementPoints = 0
    
    var matchmakingIDs: [Int] = []
    
    var categoryCounts: [Int: Int] = [:]
    
    guard let arrayOfAchievementsDictionaries = parsedAchievementsJSON["achievements"] as? [[String:AnyObject]] else {
        print("the key 'achievements' is invalid")
        return
    }
    
    guard let arrayOfCategoryDictionaries = parsedAchievementsJSON["categories"] as? [[String:AnyObject]] else {
        print("the key 'categories' is invalid")
        return
    }
    
    
    for category in arrayOfCategoryDictionaries {
        
        if let title = category["title"] as? String, title == "Matchmaking" {
            
            guard let children = category["children"] as? [NSDictionary] else {
                print("the key children is invalid")
                return
            }
            
            for child in children {
                
                guard let categoryID = child["categoryId"] as? Int else{
                    print("The key 'categoryId' is invalid")
                    return
                }
                
                matchmakingIDs.append(categoryID)
            }
            
        }
    }
    
    for achievement in arrayOfAchievementsDictionaries {
        
        numAchievements += 1
        
        if let achievementPointGreaterThanTen = achievement["points"] as? Int, achievementPointGreaterThanTen > 10 {
            print("achievement greater than 10 is found")
            cardsGreaterThan10 += 1
        }
        
        if let achievementPerCard = achievement["points"] as? Int, achievementPerCard > -1 {
            print("achievement greater than 0 found")
            sumAchievementPoints += achievementPerCard
        }
        
        if let coolRunningMission = achievement["title"] as? String, coolRunningMission.range(of: "Cool Running") != nil {
            let missionDescription = achievement["description"] as? String
            print(missionDescription)
        }
        
        guard let categoryID = achievement["categoryId"] as? Int else{
            print("The key 'categoryId' is invalid")
            return
        }
        
        if categoryCounts[categoryID] == nil {
            categoryCounts[categoryID] = 0
        }
        
        if let currentCount = categoryCounts[categoryID] {
            categoryCounts[categoryID] = currentCount + 1
        }
    }
    
    var matchmakingAchievementCount = 0
    
    for matchmakingID in matchmakingIDs {
        if let categoryCount = categoryCounts[matchmakingID] {
            matchmakingAchievementCount += categoryCount
        }
    }
    print(matchmakingAchievementCount)
    
    // Calculate average point value per Achievement
    print("Average Achievement: \(Double(sumAchievementPoints)/Double(numAchievements))")
    
}

parseJSONAsDictionary(parsedAchievementsJSON)
