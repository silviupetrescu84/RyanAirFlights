//
//  Station.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

struct Market: Codable {
    var code: String?
    var group: String?
    
}

struct Station : Codable {
    var code: String?
    var name: String?
    var alternativeName: String?
    var alias: [String]?
    var countryCode: String?
    var countryName: String?
    var countryAlias: String?
    var countryGroupCode: String?
    var countryGroupName: String?
    var timeZoneCode: String?
    var latitude: String?
    var longitude: String?
    var mobileBoardingPass: Bool?
    var markets: [Market]?
    var notices: String? //TO DO Identify actual type
}

struct StationsResponse: Codable {
    var stations: [Station]?
}

extension Array where Element == Station {
    func checkStationExists(string: String) -> Bool { //We check to see if the string from the textfield exists in the array to make 100% sure a valid station was selected
        let components = string.components(separatedBy: " - ")
        if components.count > 1 {
            let (name, code) = (components[0], components[1])
            for item in self {
                if item.code == code && item.name == name {
                    return true
                }
            }
        }
        return false
    }
    
    func getStation(string: String) -> Station? {
        let components = string.components(separatedBy: " - ")
        if components.count > 1 {
        let (name, code) = (components[0], components[1])
               for item in self {
                   if item.code == code && item.name == name {
                       return item
                   }
               }
           }
        return nil
    }
}
    
