//
//  Service.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

class NSURLService : CloudService {
    static let session = URLSession(configuration: .ephemeral)
    
    var headers: [String:String]
    var serviceString    = "localhost:8080"
    var basePath        = ""

    required public init() {
        headers = [String:String]()
        
        headers["Content-Type"]     = "application/json"
        headers["Cache-Control"]    = "No-Cache"
        headers["Accept"]            = "*/*"
        headers["Accept-Encoding"]    = "gzip, deflate"
    }
    
    func send(request: URLRequest, completion: @escaping (Error?, Any?) -> Void) -> Void {
        let task = NSURLService.session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode < 200 || httpResponse.statusCode > 399 {
                    let serverMsg        = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                    
                    completion(NSError(domain: Bundle.main.bundleIdentifier!,
                                       code: httpResponse.statusCode,
                                       userInfo: [NSLocalizedDescriptionKey: serverMsg]), nil)
                    
                    return
                }
            }
                        
            completion(error, data)
        }
        task.resume()
    }
    
    func get(endpoint: String, parameters: [String:Any] = [:], completion: @escaping (Error?, Any?) -> Void) -> Void {
        var queryString    = ""
        
        for aKey in parameters.keys {
            if let paramValue = (parameters[aKey] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if queryString.count > 1 {
                    queryString.append("&")
                } else {
                    queryString.append("?")
                }
                queryString.append("\(aKey)=\(paramValue)")
            }
        }
        
        var request        = URLRequest(url: URL(string: "\(endpoint)\(queryString)")!,
                                        cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 30.0)
        
        request.httpMethod          = "GET"
        request.allHTTPHeaderFields = headers
        
        send(request: request, completion: completion)
    }
    
    func post(endpoint: String, parameters: [String:Any], completion: @escaping (Error?, Any?) -> Void) -> Void {
        var request = URLRequest(url: URL(string: endpoint)!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 30.0)
        request.httpMethod          = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody            = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        send(request: request, completion: completion)
    }
}
