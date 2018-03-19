//
//  MapViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/18/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
//    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UdacityClient.sharedInstance().getUdacityStudentData(completionHandlerForUdacityStudentData: {(success, error) in
            
            if success {
                print("Udacity Public Data Retrieval successful")
            } else {
                print("An error has occurred to retrive student data")
            }
        })
        
        ParseClient.sharedInstance().getStudentLocation({(success, result, error) in
            
            if success {
                print("Parse Location data retrieval successful")
            } else {
                print("An error has occurred to retrieve location")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations({(success, result, error) in performUIUpdatesOnMain {
            
            if success {
                self.reloadMapView()
            }
            
            if let _ = error {
                print("Failed to download locations")
            }
        }})
    }
    
    func reloadMapView(){
        
        if !annotations.isEmpty {
            mapView.removeAnnotations(annotations)
            annotations.removeAll()
        }
        
        let locations = StudentData.sharedInstance.studentLocations
        
        for information in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            if let latitude = information.latitude, let longitude = information.longitude {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = information.firstName!
                let last = information.lastName!
                let mediaURL = information.mediaURL ?? ""
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
        }
        
        // When the array is complete, we add the annotations to the map.
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    // MARK: Actions
    
}
