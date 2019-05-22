//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by aziz on 22/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: String
    let updatedAt: String
    var mapString: String?
    var mediaURL: String
    var firstName: String
    var lastName: String
    var uniqueKey: String?
    var latitude: Double
    var longitude: Double
}
