//
//  Pin+CoreDataProperties.swift.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 6/23/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import CoreData


extension Pin {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: NSSet?
    
}

// MARK: Generated accessors for photos
extension Pin {
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
