//
//  ISO8601.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    static let shortISO8601 : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000"
        return df
    }()
    static var shortTimeFormatter: DateFormatter = {
        let df    = DateFormatter()
        
        df.dateStyle    = DateFormatter.Style.none
        df.timeStyle    = DateFormatter.Style.short
        
        return df
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    var shortISO8601: String {
        return Formatter.shortISO8601.string(from: self)
    }
    
    var shortTimeFormat: String {
        return Formatter.shortTimeFormatter.string(from: self)
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    var shortISO8601: Date? {
        return Formatter.shortISO8601.date(from: self)
    }
    
    var shortTimeFormat: Date? {
       return Formatter.shortTimeFormatter.date(from: self)
   }
}

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd" //Using this one so it's easy to create the parameter for the query
    return formatter
}
