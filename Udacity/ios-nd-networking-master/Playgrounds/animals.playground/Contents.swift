//
//  animals.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForAnimalsJSON = Bundle.main.path(forResource: "animals", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawAnimalsJSON = try? Data(contentsOf: URL(fileURLWithPath: pathForAnimalsJSON!))

/* Error object */
var parsingAnimalsError: NSError? = nil

/* Parse the data into usable form */
var parsedAnimalsJSON = try! JSONSerialization.jsonObject(with: rawAnimalsJSON!, options: .allowFragments) as! NSDictionary

func parseJSONAsDictionary(_ dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    
    guard let photosDictionary = parsedAnimalsJSON["photos"] as? NSDictionary else{
        print("photos key not found in \(parsedAnimalsJSON)")
        return
    }
    
    guard let numberOfAnimalPhotos = photosDictionary["total"] as? Int else {
        print("the number can not be found under total")
        return
    }
    print(numberOfAnimalPhotos)
    
    guard let photoDictionaryArray = photosDictionary["photo"] as? [[String:AnyObject]] else {
        print("the array key photo is not available")
        return
    }
    
    for (index, photo) in photoDictionaryArray.enumerated() {
        
        print("\(index): \(photo)")
        
        guard let commentDictionary = photo["comment"] as? [String:AnyObject] else {
            print("the comment can not be found")
            return
        }
        
        guard let content = commentDictionary["_content"] as? String else {
            print("the key content can not be found")
            return
        }
        
        if content.range(of: "interrufftion") != nil {
            print(index)
        }
        
        if let photoURL = photo["url_m"] as? String, index == 2 {
            print(photoURL)
        }
    }
}

parseJSONAsDictionary(parsedAnimalsJSON)
