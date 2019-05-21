//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by aziz on 20/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation


struct LoginResponse: Codable {
    let account: InsideAccount
    let session: InsideSession
    
}

struct InsideAccount: Codable {
    let registered: Bool
    let key: String
}

struct InsideSession: Codable {
    let id: String
    let expiration: String
}
