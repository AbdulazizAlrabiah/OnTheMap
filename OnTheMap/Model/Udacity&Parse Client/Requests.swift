//
//  Requests.swift
//  OnTheMap
//
//  Created by aziz on 20/05/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import Foundation

class Requests {
    
    struct user {
        static var userId = ""
        static var sessionId = ""
        static var objectId = ""
    }
    
    struct Endpoints {
        static let UdacityBase = "https://onthemap-api.udacity.com/v1/session"
        static let ParseBase = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let UserInfo = "https://onthemap-api.udacity.com/v1/users/"
        
        static func locationURL(limit: Int = 100, order: String = "-updatedAt") -> String {
            return ParseBase + "?order=\(order)" + "&limit=\(limit)"
        }
        
        static func studentInfo(Id: String = user.userId) -> String {
            return UserInfo + Id
        }
    }
    
    
    class func request<T: Codable>(url: String, method: String, body: Data?, completion: @escaping ((T) -> Void), errorr: @escaping ((String) -> Void)) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        if method == "GET" {
            
        } else if method == "POST" {
            request.httpBody = body
        }
        request.allHTTPHeaderFields = headers(method: method)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    errorr(StatusCodes.StatusCodes.connection.rawValue)
                }
                return
            }
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    errorr(StatusCodes.StatusCodes.connection.rawValue)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    errorr(StatusCodes.StatusCodes.connection.rawValue)
                }
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 400 else {
                
                print(String(data: data, encoding: .utf8)!)
                do {
                    let range = Range(5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    let object = try JSONDecoder().decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        errorr(StatusCodes().handleErrors(status: object.status))
                    }
                } catch {
                    errorr(error.localizedDescription)
                }
                return
            }
            do {
                var newData = data
                //Check if the url from udacity then skip the first 5 letters
                if url == Endpoints.UdacityBase || url == Endpoints.studentInfo() {
                    let range = Range(5..<data.count)
                    newData = data.subdata(in: range)
                }
                let object = try JSONDecoder().decode(T.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(object)
                }
            } catch {
                errorr(StatusCodes.StatusCodes.connection.rawValue)
            }
        }.resume()
    }
    //All headers for the requests
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
    
    class func Login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        print("handleing")
        let account = InsideUdacity(username: username, password: password)
        let data = loginRequest(udacity: account)
        let body = try! JSONEncoder().encode(data)
        
        request(url: Endpoints.UdacityBase, method: "POST", body: body , completion: { (results: LoginResponse) in
            
            user.userId = results.account.key
            user.sessionId = results.session.id

            completion(true, nil)
        })
        { (error) in
            completion(false, error)
        }
    }
    
    class func Logout(completion: @escaping (Bool) -> Void) {
        
        request(url: Endpoints.UdacityBase, method: "DELETE", body: nil, completion: { (results: LogoutResponse) in
            completion(true)
        }) { (error) in
            completion(false)
        }
    }
    
    class func getStudentsLocation(completion: @escaping (LocationResponse) -> Void, err: @escaping (String) -> Void) {
        
        request(url: Endpoints.locationURL(), method: "GET", body: nil, completion: { (results: LocationResponse) in
            completion(results)
        }) { (error) in
            err(error)
        }
    }
    
    class func getStudentName(completion: @escaping (UserInfoResponse) -> Void, err: @escaping (String) -> Void) {
        
        request(url: Endpoints.studentInfo(), method: "GET", body: nil, completion: { (results: UserInfoResponse) in
            completion(results)
        }) { (error) in
            err(error)
        }
    }
    
    class func postStudentLocation(student: PostStudentLocationRequest, completion: @escaping (PostStudentLocationResponse) -> Void, err: @escaping (String) -> Void) {
        
        let body = try! JSONEncoder().encode(student)
        
        request(url: Endpoints.ParseBase, method: "POST", body: body, completion: { (results: PostStudentLocationResponse) in
            
            user.objectId = results.objectId
            completion(results)
        }) { (error) in
            err(error)
        }
    }
}
