//
//  UserInfoResponse.swift
//  OnTheMap
//
//  Created by aziz on 24/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
