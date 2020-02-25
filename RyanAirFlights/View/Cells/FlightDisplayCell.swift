//
//  FlightDisplayCell.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation
import UIKit
class FlightDisplayCell : UITableViewCell {
    @IBOutlet weak var mainStackView: UIStackView!
    
    
    func setupWith(flightDates: [Flight], currency: String) {
        for subView in mainStackView.subviews {
            mainStackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        if flightDates.count == 0 {
            createLabel(text: "No flights", stackView: mainStackView)
        } else {
            for flightDate in flightDates {
                if flightDate.time == nil { continue }
                for item in flightDate.time! {
                    //To do a simpler conversion rather than going String->Date->String
                    createLabel(text: "Time : " + item.shortISO8601!.shortTimeFormat, stackView: mainStackView)
                }
                if flightDate.regularFare != nil {
                    for fare in flightDate.regularFare!.fares {
                        if fare.amount == nil || fare.type == nil { continue }
                        createLabel(text: "Price : " + fare.type! + " - " + String(format:"%0.2f %@", fare.amount!, currency) , stackView: mainStackView)
                        //Add buy now button
                    }
                }
            }
        }
        
    }
    
    func createLabel(text: String, stackView: UIStackView) {
        let label = PaddedLabel()
        label.text = text
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        stackView.addArrangedSubview(label)
    }
}

