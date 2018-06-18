//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 6/17/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(title: String, flickrId: String, flickrUrl: String, data: NSData?, _ context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.flickrId = flickrId
            self.flickrUrl = flickrUrl
            self.data = data
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
