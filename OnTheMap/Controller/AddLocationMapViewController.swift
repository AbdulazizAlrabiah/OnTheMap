//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by aziz on 23/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    var student: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillAnnotation()
        zoom()
    }
    
    @IBAction func postLocationButton(_ sender: Any) {
        
    }
    
    func fillAnnotation() {
        
        let lat = CLLocationDegrees(student.latitude)
        let long = CLLocationDegrees(student.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = student.firstName
        let last = student.lastName
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        
        annotations.append(annotation)
        
        self.mapView.addAnnotations(self.annotations)
    }
    
    func zoom() {
        
        let location = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 250, longitudinalMeters: 250)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
