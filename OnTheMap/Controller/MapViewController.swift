//
//  MapViewController.swift
//  OnTheMap
//
//  Created by aziz on 21/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations: [StudentLocation] = []
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation()
    }
    
    @IBAction func LogoutButtorn(_ sender: Any) {
        
        Requests.Logout { (flag) in
            if flag {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.alertFailure(error: StatusCodes.StatusCodes.errorLoggingOut.rawValue)
            }
        }
    }
    
    @IBAction func RefreshButton(_ sender: Any) {
        
        getLocation()
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        
        let addLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocation") as! UINavigationController
        
        present(addLocationVC, animated: true, completion: nil)
    }
    
    func fillAnotationArray(){
        
        for dictionary in studentLocations {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func getLocation() {
        
        Requests.getStudentsLocation(completion: { (location) in
            self.studentLocations = location.results!
            self.fillAnotationArray()
        }) { (error) in
            self.alertFailure(error: error)
        }
    }
    
    func alertFailure(error: String) {
        
        let alertVC = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        showDetailViewController(alertVC, sender: nil)
    }
}
