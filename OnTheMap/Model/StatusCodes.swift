//
//  StatusCodes.swift
//  OnTheMap
//
//  Created by aziz on 24/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

struct StatusCodes {
    
    enum StatusCodes: String {
        case e403 = "Invalid email or password"
        case connection = "There was an error retrieving the data check your connection"
        case none = "error try again"
    }
    
    func handleErrors(status: Int) -> String {
        
        switch status {
        case 403:
            return StatusCodes.e403.rawValue
        default:
            return StatusCodes.none.rawValue
        }
    }

}

