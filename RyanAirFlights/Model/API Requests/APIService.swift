//
//  APIService.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

enum PossibleServices {
    case Alamofire
    case NSURLSession
    case none
}

let currentService: PossibleServices = .Alamofire

import Foundation
let jsonEncoder: JSONEncoder    = { let enc = JSONEncoder(); enc.dateEncodingStrategy = .iso8601; enc.outputFormatting = [.sortedKeys]; return enc }()
let jsonDecoder: JSONDecoder    = { let dec = JSONDecoder(); dec.dateDecodingStrategy = .iso8601; return dec }()

let stationsEndPoint = "https://tripstest.ryanair.com/static/stations.json"
let flightsEndPoint = "https://sit-nativeapps.ryanair.com/v4/Availability"

protocol APIRequests {

    func getStations(completion: @escaping (Error?, Any?) -> Void)
    
    func getFligts(for parameters: [String:String]?, completion: @escaping (Error?, Any?) -> Void)
}
    
class APIService: APIRequests {
    
    static var shared: APIRequests! = {
#if UI_TEST //Disabled for now but the UI Tests can connect to local mock API if needed
        return APIMockService()
#else
        return APIService()
#endif
    }()

    static var service: CloudService! {
        get {
            if currentService == .Alamofire {
                return AlamoService()
            } else if currentService == .NSURLSession {
                return NSURLService()
            } else {
                return nil //If it's not set it will crash
            }
        }
    }
    
    // Gets data from API for directly Codable objects
    private func getAPIData<T>(endpoint: String, parameters: [String: String] = [:], type: T.Type, completion: @escaping (Error?, Any?) -> Void) where T: Decodable {
        guard APIService.service != nil else {
            completion(NSError(domain: Bundle.main.bundleIdentifier!,
                               code: -2,
                               userInfo: [NSLocalizedDescriptionKey: "No service defined to query"]), nil)
            return
        }
        
        APIService.service.get(endpoint: endpoint, parameters: parameters) { error, result in
            if error != nil {
                completion(self.normaliseError(error: error, data: result as? Data), nil)
            } else if let data = result as? Data {
                
                do {
                    let object = try jsonDecoder.decode(type, from: data)
                    
                    completion(nil, object)
                } catch {
                    completion(error, nil)
                }
            } else {
                completion(NSError(domain: Bundle.main.bundleIdentifier!,
                                   code: -3,
                                   userInfo: [NSLocalizedDescriptionKey: "Invalid API Response"]), nil)
            }
        }
    }
    
    func getStations(completion: @escaping (Error?, Any?) -> Void) {
        getAPIData(endpoint: stationsEndPoint, type: StationsResponse.self, completion: completion)
    }
    
    func getFligts(for parameters: [String : String]?, completion: @escaping (Error?, Any?) -> Void) {
        getAPIData(endpoint: flightsEndPoint, parameters: (parameters != nil ? parameters! : ["":""]), type: FlightResponse.self, completion: completion)
    }
    
    private func normaliseError(error: Error?, data: Data?) -> Error? {
        guard let err = error else { return error }
        
        let nsError = err as NSError
        
        if data != nil,
            let result = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String: Any],
            let message = result["message"] as? String {
            var userInfo    = nsError.userInfo
            
            userInfo[NSLocalizedDescriptionKey]    = message
            
            return NSError(domain: nsError.domain, code: nsError.code, userInfo: userInfo)
        }
        return nsError
    }
}
