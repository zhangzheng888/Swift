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

class MapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    var reachability = Reachability()!
    let loadingIndicator = UIActivityIndicatorView()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.sharedInstance.getUdacityStudentData(completionHandlerForUdacityStudentData: {(success, error) in
            
            if success {
                print("Udacity Public Data Retrieval successful")
            } else {
                print("An error has occurred to retrive student data")
            }
        })
        
        ParseClient.sharedInstance.getStudentLocation({(success, result, error) in
            
            if success {
                print("Parse Location data retrieval successful")
            } else {
                print("An error has occurred to retrieve location")
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkAvailable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentLoadingAlert()
        ParseClient.sharedInstance.getStudentLocations({(success, result, error) in performUIUpdatesOnMain {
            
            if success {
                self.alert.dismiss(animated: true, completion: nil)
                self.reloadMapView()
            }
            if let _ = error {
                self.alert.dismiss(animated: true, completion: {() in
                    self.presentAlert("Failed to download", "We've failed to find student's locations. Try again later", "OK")
                })
            }
        }})
    }
    
    // MARK: Actions
    
    @IBAction func addPressed(_ sender: Any) {
        guard userLocation.objectId != nil else {
            presentAlertWithCancel("", "User " + "\"\(userLocation.firstName!)" + " " + "\(userLocation.lastName!)\"" + " Has Already Posted a Student Location. Would You Like to Overwrite Their Location?" , "Overwrite")
            return
        }
        
        guard let addLocation: AddLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController else {
            print("Loading Error, Add Location View Controller does not exist")
            return
        }
        self.present(addLocation, animated: true, completion: nil)
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        print("refreshPressed!")
        ParseClient.sharedInstance.getStudentLocations({(success, result, error) in performUIUpdatesOnMain {
            if success {
                self.reloadMapView()
            } else {
                self.presentAlert("Failed to Load", "Unable to retrieve map information. Please check network connection", "OK")
                }
            }
        })
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        showIndicator()
        UdacityClient.sharedInstance.logoutFromApplication(completionHandlerForLogout: {(success, error) in performUIUpdatesOnMain {
            
            if success {
                print("Logout Success!")
                self.dismissIndicator()
                self.dismiss(animated: true, completion: nil)
                
            } else {
                self.dismissIndicator()
                self.presentAlert("Failed to Logout", "Unable to logout. Please check network connection", "OK")
                return
                }
            }
        })
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // MARK: MapViewDelegate
    
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
}

private extension MapViewController {

    // MARK: Alert Controller

    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func networkAvailable() {
        reachability.whenReachable = { _ in
            print("Network reachable")
        }
        
        reachability.whenUnreachable = { _ in
            self.presentAlert("Network Error", "There is a problem with network connectivity", "OK")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    // MARK: Alert Controller with Cancel

    private func presentAlertWithCancel(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            
            let addLocation: AddLocationViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController)!
            self.present(addLocation, animated: true, completion: nil)
            NSLog("The \"\(title)\" alert occured.")
        }))
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        })
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Activity Indicator
    
    private func presentLoadingAlert() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showIndicator() {
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func dismissIndicator() {
        loadingIndicator.stopAnimating()
    }
}
