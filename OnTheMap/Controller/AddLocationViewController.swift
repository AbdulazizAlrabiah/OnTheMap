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

        if checkEmpty() {
            alertFailure(message: "Empty location field or website field")
        } else if (websiteTextField.text?.starts(with: ("https://")))! == false {
            alertFailure(message: "Enter a website that begins with https://")
        }
        else {
            let location = MKLocalSearch.Request()
            location.naturalLanguageQuery = locationTextField.text
            let request = MKLocalSearch(request: location)
            
            request.start { (response, error) in
                guard let response = response else {
                    self.alertFailure(message: "Enter a valid location address")
                    return }
                let lat = response.boundingRegion.center.latitude as Double
                let long = response.boundingRegion.center.longitude as Double
                self.getStudentInfo(lat: lat, long: long)
            }
        }
    }
    
    func getStudentInfo(lat: Double, long: Double) {
        
        Requests.getStudentName(completion: { (student) in
            let info = StudentLocation(createdAt: "", updatedAt: "", mapString: self.locationTextField.text, mediaURL: self.websiteTextField.text, firstName: student.firstName , lastName: student.lastName, uniqueKey: Requests.user.userId, latitude: lat, longitude: long)
            
            self.fillInfoAndPass(student: info)
        }) { (error) in
            self.alertFailure(message: error)
        }
    }
    
    func fillInfoAndPass(student: StudentLocation) {
        
        let mapVC = self.storyboard!.instantiateViewController(withIdentifier: "PostLocation") as! AddLocationMapViewController
        mapVC.student = student
        mapVC.title = "Add Location"
        self.navigationController?.pushViewController(mapVC, animated: true)
        
        activityIndicator.stopAnimating()
    }
    
    func checkEmpty() -> Bool {
        
        if locationTextField.text == "" || websiteTextField.text == "" {
            return true
        }
        return false
    }
    
    func alertFailure(message: String) {

        activityIndicator.stopAnimating()
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        showDetailViewController(alertVC, sender: nil)
    }
}
