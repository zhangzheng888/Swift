//
//  DetailedLocationViewController.swift
//  OnTheGrid
//
//  Created by Kevin Zhang on 3/25/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import UIKit
import MapKit

class DetailedLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Properties
    
    var userLocationString: String!
    var userMediaURL: String!
    var userLongitude: Double!
    var userLatitude: Double!
    
    // MARK: Outlet
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailTextfield: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = userLocationString
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler:{(response, error) in performUIUpdatesOnMain {
            
            if error != nil {
                print("Cannot Find Location", "Cannot find location, please try again.", "OK")
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
                }
            }
        }
        })
    }
    
    // MARK: Actions
    
    @IBAction func backPressed(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishPressed(_ sender: Any){
        
        print(userLocation.objectId as Any)
        
        userDidTapView(self)
        
        guard let text = detailTextfield.text, !text.isEmpty else {
            print("Location text field is empty")
            return
        }
        self.userMediaURL = text
        
        if userLocation.objectId == nil {
            
            ParseClient.sharedInstance().postStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                
                if success {
                    print("Post Location Success!")
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } else {
                    print("Post Location Unsuccessful.")
                }
                }
            })
        } else {
            
            ParseClient.sharedInstance().putStudentLocation(userLocationString, userMediaURL, userLatitude, userLongitude, {(success, error) in performUIUpdatesOnMain {
                if success {
                    print("Put Location Success!")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("Put Location Unsuccessful.")
                }
                }
            })
            
        }
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(detailTextfield)
    }

    // MARK: MKMapViewDelegate Methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}

// MARK: - DetailedLocationViewController: UITextFieldDelegate

extension DetailedLocationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - DetailedLocationViewController (Keyboard Notifications)

private extension DetailedLocationViewController {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if detailTextfield.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
