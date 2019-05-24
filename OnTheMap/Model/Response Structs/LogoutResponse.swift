//
//  LogoutResponse.swift
//  OnTheMap
//
//  Created by aziz on 21/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: InsideSessionLogout
}

struct InsideSessionLogout: Codable {
    let id: String
    let expiration: String
}
