//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 6/18/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }
    
    @NSManaged public var data: NSData?
    @NSManaged public var flickrId: String?
    @NSManaged public var flickrUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var pin: Pin?
    
}
