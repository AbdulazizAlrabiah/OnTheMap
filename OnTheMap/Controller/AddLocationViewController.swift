//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by aziz on 23/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func Cancelbutton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        let location = MKLocalSearch.Request()
        location.naturalLanguageQuery = locationTextField.text
        let request = MKLocalSearch(request: location)
        
        request.start { (response, error) in
            guard let response = response else { return }
            let lat = response.boundingRegion.center.latitude as Double
            let long = response.boundingRegion.center.longitude as Double
            self.getStudentInfo(lat: lat, long: long)
        }
    }
    
    func getStudentInfo(lat: Double, long: Double) {
        
        Requests.getStudentName { (student) in
          let info = StudentLocation(createdAt: "", updatedAt: "", mapString: self.locationTextField.text, mediaURL: self.websiteTextField.text, firstName: student.firstName , lastName: student.lastName, uniqueKey: Requests.user.userId, latitude: lat, longitude: long)
            
            self.fillInfoAndPass(student: info)
        }
    }
    
    func fillInfoAndPass(student: StudentLocation) {
        
        let mapVC = self.storyboard!.instantiateViewController(withIdentifier: "PostLocation") as! AddLocationMapViewController
        mapVC.student = student
        mapVC.title = "Add Location"
        self.navigationController?.pushViewController(mapVC, animated: true)
        
        activityIndicator.stopAnimating()
    }
}
