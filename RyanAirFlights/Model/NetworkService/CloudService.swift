//
//  CloudService.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

protocol CloudService {
    func get(endpoint: String, parameters: [String:Any], completion: @escaping (Error?, Any?) -> Void) -> Void
    
    func post(endpoint: String, parameters: [String:Any], completion: @escaping (Error?, Any?) -> Void) -> Void
}
