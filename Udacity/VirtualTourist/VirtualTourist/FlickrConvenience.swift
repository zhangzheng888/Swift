//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 4/21/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//
import UIKit

extension FlickrClient {
    
    // MARK: Search Photos
    
    func getLocationPhotos(pin: Pin, latitude: Double, longitude: Double, _ completionHandlerForSearch: @escaping (_ result: [Photo]?, _ error: NSError?) -> Void) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        let boxLatLeft = latitude - 1
        let boxLngLeft = longitude - 1
        let boxLatRight = latitude + 1
        let boxLngRight = longitude + 1
        let bBox = "\(boxLngLeft),\(boxLatLeft),\(boxLngRight),\(boxLatRight)"
        
        let randomNum: UInt32 = arc4random_uniform(10)
        let randomPage: Int = Int(randomNum)
        
        let parameters = [
            ParameterKeys.PerPage: 10,
            ParameterKeys.BBox: bBox,
            ParameterKeys.Format: "json",
            ParameterKeys.Page: randomPage
            ] as [String : Any]
        let method: String = Methods.Search
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            if let error = error {
                completionHandlerForSearch(nil, error)
            } else {
                if let results = results as? [String:AnyObject] {
                    let flickrPhotos = FlickrPhoto.flickrPhotosFrom(results)
                    var photos: [Photo] = [Photo]()
                    for flickrPhoto in flickrPhotos {
                        let photo = Photo(title: flickrPhoto.title, flickrId: String(flickrPhoto.id),  flickrUrl: flickrPhoto.photoUrl, data: nil, stack.context)
                        photo.pin = pin
                        photos.append(photo)
                    }
                    completionHandlerForSearch(photos, nil)
                } else {
                    completionHandlerForSearch(nil, NSError(domain: "search parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse FlickrPhotos"]))
                }
            }
        }
    }
}
