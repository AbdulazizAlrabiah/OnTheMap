//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by aziz on 22/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}
