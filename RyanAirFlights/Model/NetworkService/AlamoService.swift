//
//  AlamoService.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation
import Alamofire
class AlamoService: CloudService  {
    func get(endpoint: String, parameters: [String:Any] = [:], completion: @escaping (Error?, Any?) -> Void) -> Void {
    
        AF.request(endpoint,method: .get, parameters: parameters)
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
          .response { response in
            completion(response.error, response.data)
        }
    }
    
    func post(endpoint: String, parameters: [String:Any], completion: @escaping (Error?, Any?) -> Void) -> Void {
        AF.request(endpoint,method: .post, parameters: parameters)
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
          .response { response in
            completion(response.error, response.data)
        }
    }
    
    
}
