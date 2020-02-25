//
//  Flight.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

struct Fare: Codable {
    var amount: Double?
    var count: Int?
    var type: String?
    var hasDiscount: Bool?
    var publishedFare: Double?
    var discountInPercent: Int?
    var hasPromoDiscount: Bool?
    var discountAmount: Double?
}

class MainFare: Codable {
    var fareKey: String?
    var fareClass: String?
    var fares: [Fare]
}

class RegularFare: MainFare {
    
    var faresLeft: Int?
    var timeUTC: [String]?
    var timeUTCDate: [Date]? {
        get {
            var items = [Date]()
            if timeUTC != nil {
                for item in timeUTC! {
                    if let itemDate = item.shortISO8601 {
                        items.append(itemDate)
                    }
                }
            }
            return items
        }
    }
    var duration: String?
    var flightNumber: String?
    var infantsLeft: Int?
    var	flightKey: String?
    var businessFare: MainFare?
}

struct Flight: Codable {
    var time : [String]?
    var timeDate : [Date]? {
        get {
            var items = [Date]()
            if time != nil {
                for item in time! {
                    items.append(item.shortISO8601!)
                }
            }
            return items
        }
    }
    var regularFare: RegularFare?
    
}
struct FlightDate: Codable {
    var dateOut: String?
    var dateOutDate: Date? {
        get { return dateOut?.shortISO8601 }
    }
    var flights: [Flight]?
}

struct Trip: Codable {
    var origin: String?
    var destination: String?
    var dates: [FlightDate]?
}

struct FlightResponse: Codable {
    var currency: String?
    var serverTimeUTC: String?
    var serverTimeUTCDate: Date? {
        get { return serverTimeUTC?.shortISO8601 }
    }
    var currPrecision: Int?
    var trips: [Trip]?
    
}
