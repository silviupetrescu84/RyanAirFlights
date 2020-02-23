//
//  GlobalData.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation

class GlobalData {
    static var shared  = GlobalData()
    var stations : [Station] = [Station]()
}
