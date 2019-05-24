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
        
        static func studentInfo(Id: String = user.userId) -> String{
            return UserInfo + Id
        }
    }
    
    class func request<T: Codable>(url: String, method: String, body: Data?, completion: @escaping ((T) -> Void), errorr: @escaping ((String) -> Void)) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        
        if method == "GET" {
            // request.url = urlWith(url: url)
        } else if method == "POST" {
            request.httpBody = body
        }
        request.allHTTPHeaderFields = headers(method: method)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    errorr("Check connection")
                }
                print("error1")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                // handle error
                DispatchQueue.main.async {
                    errorr("error")
                }
                print("error2")
                return
            }
            guard response.statusCode >= 200 && response.statusCode < 400 else {
                // handle server error
                // change how to handle the error!
                print(String(data: data!, encoding: .utf8)!)
//                let range = Range(5..<data!.count)
//                let newData = data?.subdata(in: range) /* subset response data! */
//                let object = try! JSONDecoder().decode(ErrorResponse.self, from: newData!)
//                print(object)
                DispatchQueue.main.async {
                    errorr("error")
                }
                print("error3")
                return
            }
            guard let data = data else {
                // handle no data
                DispatchQueue.main.async {
                    errorr("error")
                }
                print("error4")
                return
            }
            // handle data
            do {
                print("hi")
                var newData = data
                if url == Endpoints.UdacityBase || url == Endpoints.studentInfo() {
                    let range = Range(5..<data.count)
                    newData = data.subdata(in: range)
                }
                let object = try JSONDecoder().decode(T.self, from: newData)
                
                DispatchQueue.main.async {
                    completion(object)
                }
            } catch {
                
                do {
                    //change
//                    let range = Range(5..<data.count)
//                    let newData = data.subdata(in: range) /* subset response data! */
                    print(String(data: data, encoding: .utf8)!)
                } catch {
                    //handle error
                    
                }
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
    
    class func Login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        print("handleing")
        let account = InsideUdacity(username: username, password: password)
        let data = loginRequest(udacity: account)
        let body = try! JSONEncoder().encode(data)
        
        request(url: Endpoints.UdacityBase, method: "POST", body: body , completion: { (results: LoginResponse) in
            
            user.userId = results.account.key
            user.sessionId = results.session.id
            print(results)
            completion(true, nil)
        })
        { (error) in
            completion(false, error)
            print(error)
        }
    }
    
    class func Logout() {
        
        request(url: Endpoints.UdacityBase, method: "DELETE", body: nil, completion: { (results: LogoutResponse) in
            
            print(results)
        }) { (error) in
            print(error)
        }
    }
    
    class func getStudentsLocation(completion: @escaping (LocationResponse) -> Void) {
        
        request(url: Endpoints.locationURL(), method: "GET", body: nil, completion: { (results: LocationResponse) in
            //print(results)
            completion(results)
        }) { (error) in
            print(error)
        }
    }
    
    class func getStudentName(completion: @escaping (UserInfoResponse) -> Void) {
        
        request(url: Endpoints.studentInfo(), method: "GET", body: nil, completion: { (results: UserInfoResponse) in
            print(results)
            completion(results)
        }) { (error) in
            print(error)
        }
    }
    
    class func postStudentLocation(student: PostStudentLocationRequest, completion: @escaping (PostStudentLocationResponse) -> Void) {
        
        let body = try! JSONEncoder().encode(student)
        
        request(url: Endpoints.ParseBase, method: "POST", body: body, completion: { (results: PostStudentLocationResponse) in
            print(results)
            user.objectId = results.objectId
            completion(results)
        }) { (error) in
            
            print(error)
        }
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
