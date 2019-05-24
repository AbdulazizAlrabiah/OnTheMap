//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by aziz on 20/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct loginRequest: Codable {
    let udacity: InsideUdacity
}

struct InsideUdacity: Codable {
    let username: String
    let password: String
}
