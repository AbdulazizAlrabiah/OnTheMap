//
//  TableViewController.swift
//  OnTheMap
//
//  Created by aziz on 21/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController  {
    
    var studentLocations: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocation()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        Requests.Logout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        getLocation()
    }
    
    @IBAction func addLocationButton(_ sender: Any) {
        
        let addLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocation") as! UINavigationController
        
        present(addLocationVC, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfo")!
        let student = studentLocations[indexPath.row]
        
        cell.textLabel?.text = (student.firstName + student.lastName)
        cell.imageView?.image = UIImage(named: "icon_pin")
        //maybe
        cell.detailTextLabel?.text = student.mediaURL!
        //
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if let toOpen = studentLocations[indexPath.row].mediaURL {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    
    func getLocation() {
        
        Requests.getStudentsLocation { (location) in
            self.studentLocations = location.results!
            self.tableView.reloadData()
        }
    }
}
