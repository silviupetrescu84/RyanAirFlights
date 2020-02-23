//
//  MockAPIService.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation


class MockAPIService: APIRequests {
    var mockStations = ""
    var mockFlights = ""
     
    required init() {
        if let filepath = Bundle.main.path(forResource: "MockStations", ofType: "json") {
            do {
                mockStations = try String(contentsOfFile: filepath)
            } catch {
                print ("Error reading MockStations.json")
            }
        } else {
            print ("File MockStations.json not found")
        }
    }
    
    func getStations(completion: @escaping (Error?, Any?) -> Void) {
        let data = mockStations.data(using: .utf8)
        let object = try! jsonDecoder.decode(StationsResponse.self, from: data!)
        completion(nil, object)
    }
    
    func getFligts(for parameters: [String : String]?, completion: @escaping (Error?, Any?) -> Void) {
        let data = mockFlights.data(using: .utf8)
        let object = try! jsonDecoder.decode(FlightResponse.self, from: data!)
        completion(nil, object)
    }
}
