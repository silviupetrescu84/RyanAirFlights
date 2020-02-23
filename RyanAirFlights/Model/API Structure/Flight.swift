//
//  Flight.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

struct Fare: Codable {
    var ammount: Double?
    var count: Int?
    var type: String?
    var hasDiscount: Bool?
    var publishedFare: Double?
}

class MainFare: Codable {
    var fareKey: String?
    var fareClass: String?
    var fares: [Fare]
}

class RegularFare: MainFare {
    
    var faresLeft: Int?
    var timeUTC: [String]? {
        didSet {
            guard timeUTC != nil else { return }
            timeUTCDate = [Date]()
            
            for item in timeUTC! {
                if let itemDate = item.iso8601 {
                    timeUTCDate?.append(itemDate)
                }
            }
        }
    }
    var timeUTCDate: [Date]?
    var duration: String?
    var flightNumber: String?
    var infantsLeft: Int?
    var	flightKey: String?
    var businessFare: MainFare?
}

struct Flight: Codable {
    var time : [String]? {
        didSet {
            guard time != nil else { return }
            timeDate = [Date]()
            
            for item in time! {
                if let itemDate = item.iso8601 {
                    timeDate?.append(itemDate)
                }
            }
        }
    }
    var timeDate : [Date]?
    var regularFare: RegularFare?
    
}
struct FlightDate: Codable {
    var dateOut: String? {
        didSet {
            dateOutDate = dateOut?.iso8601
        }
    }
    var dateOutDate: Date?
    var flights: [Flight]?
}

struct Trip: Codable {
    var origin: String?
    var destination: String?
    var dates: [FlightDate]?
}

struct FlightResponse: Codable {
    var currency: String?
    var serverTimeUTC: String? {
        didSet {
            serverTimeUTCDate = serverTimeUTC?.iso8601
        }
    }
    var serverTimeUTCDate: Date?
    var currPrecision: Int?
    var trips: [Trip]?
    
}
