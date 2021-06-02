//
//  AuthNetworkService.swift
//  Herald
//
//  Created by Vladislav Grokhotov on 01.06.2021.
//

import Foundation

class AuthNetworkService: NetworkService {
    
    private override init() { super.init() }
    static let shared = AuthNetworkService()
    
    private let signup = "/signup"
    private let signin = "/signin"
    private let email = "/email"
    
    func signUp(with user: POSTUser, completion: @escaping (CreatedUser) -> (), errCompletion: @escaping (String) -> ()) {
        
        components.path = signup
        
        guard
            let url = components.url
        else {
            badURL(errCompletion)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(user) else {
            print("bad http body with User")
            failed(message: self.badMessage, errCompletion: errCompletion)
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.failed(message: error.localizedDescription, errCompletion: errCompletion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.completionHandler(httpResponse.statusCode, data, completion, errCompletion)
            }
        }
        task.resume()
    }
    
    func email(with username: Username, completion: @escaping (Int) -> (), errCompletion: @escaping (String) -> ()) {
        
        components.path = email
        
        guard
            let url = components.url
        else {
            badURL(errCompletion)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(username) else {
            print("bad http body with Username")
            failed(message: self.badMessage, errCompletion: errCompletion)
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.failed(message: error.localizedDescription, errCompletion: errCompletion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.completionHandler(httpResponse.statusCode, data, completion, errCompletion)
            }
        }
        task.resume()
    }
    
    func signIn(with username: Username, key: String, completion: @escaping (UserWithToken) -> (), errCompletion: @escaping (String) -> ()) {
        
        components.path = signin
        
        guard
            let url = components.url
        else {
            badURL(errCompletion)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer " + key, forHTTPHeaderField: "Authorization")
        
        guard let httpBody = try? JSONEncoder().encode(username) else {
            print("bad http body with Username")
            failed(message: self.badMessage, errCompletion: errCompletion)
            return
        }
        
        request.httpBody = httpBody
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.failed(message: error.localizedDescription, errCompletion: errCompletion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.completionHandler(httpResponse.statusCode, data, completion, errCompletion)
            }
        }
        task.resume()
    }
}

