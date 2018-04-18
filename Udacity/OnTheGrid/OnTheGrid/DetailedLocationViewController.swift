//
//  DetailedLocationViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/25/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit
import MapKit

class DetailedLocationViewController: UIViewController {
    
    // MARK: Properties
    
    var userLocationString: String!
    var userMediaURL: String!
    var userLongitude: Double!
    var userLatitude: Double!
    let loadingIndicator = UIActivityIndicatorView()
    
    // MARK: Outlet
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailTextfield: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTextfield.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findLocation(userLocationString)
    }
    
    // MARK: Actions
    
    @IBAction func backPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishPressed(_ sender: Any){
        
        print(userLocation.objectId as Any)
        userDidTapView(self)
        guard let text = detailTextfield.text, !text.isEmpty else {
            presentAlert("Error", "Location text field is empty", "OK")
            return
        }
        userMediaURL = text
        if userLocation.objectId == nil {
            
            ParseClient.sharedInstance.postStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                    if success {
                        print("Post Location Success!")
                        self.dismiss(animated: true, completion: nil )
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapNavigationalController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                        
                    } else {
                        print("Post Location Unsuccessful.")
                        self.presentAlert("Cannot Post Location", "Please try again.", "OK")
                    }
                }
            })
        } else {
            
            ParseClient.sharedInstance.putStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                    if success {
                        print("Put Location Success!")
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapNavigationalController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        print("Put Location Unsuccessful.")
                        self.presentAlert("Cannot Post Location", "Please try again.", "OK")
                    }
                }
            })
        }
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(detailTextfield)
    }
}

extension DetailedLocationViewController: MKMapViewDelegate {

    // MARK: Search Location
    
    private func findLocation(_ location: String?) {
        showIndicator()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler:{(response, error) in performUIUpdatesOnMain {
            
            if error != nil {
                self.presentAlert("Cannot Find Location", "Cannot find location, please try again.", "OK")
                self.dismissIndicator()
            }
            
            if let mapItems = response?.mapItems {
                if let mapItem = mapItems.first {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    self.userLongitude = mapItem.placemark.coordinate.longitude
                    self.userLatitude = mapItem.placemark.coordinate.latitude
                    annotation.title = mapItem.name
                    self.mapView.addAnnotation(annotation)
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
                    self.mapView.region = region
                    self.dismissIndicator()
                }
            }
        }})
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
    
    // MARK: MKMapViewDelegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // MARK: Alert Controller
    
    private func presentAlert(_ title: String, _ message: String, _ action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(action, comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"\(title)\" alert occured.")
        }))
        present(alert, animated: true, completion: nil)
    }
}
