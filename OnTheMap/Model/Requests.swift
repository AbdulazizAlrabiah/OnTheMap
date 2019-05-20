//
//  Requests.swift
//  OnTheMap
//
//  Created by aziz on 20/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

class Requests {
    
    struct account {
        static var id = ""
        static var key = ""
    }
    
    class func Login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        print("handleing")
        let request = InsideUdacity(username: username, password: password)
        let user = loginRequest(udacity: request)
        let body = try! JSONEncoder().encode(user)
        
        fetch(url: "https://onthemap-api.udacity.com/v1/session", method: "POST", body: body , completion: { (results: LoginResponse) in
            DispatchQueue.main.async {
                completion(true)
            }
        })
        { (error) in
            
            print(error)
        }
        
    }
    
    class func fetch<T: Codable>(url: String, method: String, body: Data?, completion: @escaping ((T) -> Void), errorr: @escaping ((String) -> Void)) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        if method == "GET" {
            // request.url = urlWith(url: url)
        } else {
            request.httpBody = body
        }
        request.allHTTPHeaderFields = headers(method: method)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                errorr("error")
                print("error1")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                // handle error
                print("error2")
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 400 else {
                // handle server error
                print("error3")
                return
            }
            guard let data = data else {
                // handle no data
                print("error4")
                return
            }
            // handle data
            do {
                print("hi")
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range)
                let object = try JSONDecoder().decode(T.self, from: newData)
                completion(object)
            } catch {
                // handle error
                print(error)
            }
            
            }.resume()
    }
    
    class func headers(method: String) -> [String: String] {
        var headers: [String: String] = [:]
        headers["X-Parse-Application-Id"] = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        headers["X-Parse-REST-API-Key"] = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        if method == "DELETE" {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                headers["X-XSRF-TOKEN"] = xsrfCookie.value
            }
        }
        return headers
    }
}


//        let body2 = "{\"udacity\": {\"username\": \"\(request.username)\", \"password\": \"\(request.password)\"}}".data(using: .utf8)
//        let body = """
//        {"udacity":
//        {"username": "\(request.username)",
//        "password": "\(request.password)"
//        }
//        }
//        """.data(using: .utf8)
