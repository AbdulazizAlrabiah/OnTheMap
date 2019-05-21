//
//  MapViewController.swift
//  OnTheMap
//
//  Created by aziz on 21/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func LogoutButtorn(_ sender: Any) {
        Requests.Logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RefreshButton(_ sender: Any) {
        
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        
    }
}
