//
//  TableViewController.swift
//  OnTheMap
//
//  Created by aziz on 21/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        Requests.Logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        
    }
}
