//
//  MapController.swift
//  VirtualTourist
//
//  Created by Kevin Zhang on 4/30/18.
//  Copyright © 2018 Kevin Zhang. All rights reserved.
//

import MapKit
import CoreData

class MapPinsViewController: UIViewController {
    
    // MARK: Attributes
    @IBOutlet weak var mapView: MKMapView!
    
    // Annotations
    var annotations: [MKAnnotation] = [MKAnnotation]()
    // Pins
    var pins: [Pin] = [Pin]()
    var selectedPin: Pin?
    // Stack
    var stack: CoreDataStack?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
        pins = fetchPins()
        
        mapView.delegate = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapPinsViewController.longPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecognizer)
        
        populateMap()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let collectionVC = segue.destination as! PhotosCollectionViewController
            collectionVC.selectedPin = self.selectedPin
        }
    }
    
    // MARK: Pin and Annotations
    func populateMap() {
        for pin in pins {
            mapView.addAnnotation(pin as! MKAnnotation)
        }
    }
    
    func createPin(_ location: CLLocationCoordinate2D) -> Pin {
        let pin: Pin = Pin(latitude: location.latitude, longitude: location.longitude, stack!.context)
        stack!.save()
        return pin
    }
    
    func fetchPins() -> [Pin] {
        var pins = [Pin]()
        let fr: NSFetchRequest<NSFetchRequestResult> = Pin.fetchRequest()
        
        do {
            let results = try stack!.context.fetch(fr) as! [Pin]
            pins = results
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)")
        }
        
        return pins
    }
}

// MARK: MKMapViewDelegate
extension MapPinsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        selectedPin = view.annotation as? Pin
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    }
    
}

// MARK: Long Press
extension MapPinsViewController {
    func longPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        let touchPoint: CGPoint = gesture.location(in: mapView)
        let touchCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        mapView.addAnnotation(createPin(touchCoordinate))
    }
}
