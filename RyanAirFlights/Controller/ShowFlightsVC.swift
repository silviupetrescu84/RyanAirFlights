//
//  ShowFlightsViewController.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation
import UIKit
class ShowFlightsVC : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flightResponse: FlightResponse?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var parameters = [String: String]()
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        downloadFlights()
    }
    
    func downloadFlights() {
        APIService.shared.getFligts(for: parameters) { (error, flightsReponse) in
             if error == nil {
                if let currentFlightsReponse = flightsReponse as? FlightResponse {
                    self.flightResponse = currentFlightsReponse
                }
             }
             else { //To do create a main view which displays errors in a queue
                 self.showAlert(message: error?.localizedDescription)
             }
             DispatchQueue.main.async {
                self.endLoadingStations()
            }
        }
    }
    
    func endLoadingStations() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let trips = flightResponse?.trips {
            if let trip = trips[0] as Trip? {
                return trip.dates!.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trips = flightResponse?.trips {
            if (trips[0] as Trip?) != nil {
                return 1 //One row per date
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let trips = flightResponse?.trips {
            if let trip = trips[0] as Trip? {
                return dateFormatter.string(from: trip.dates![section].dateOutDate!)
            }
        }
        return ""
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FlightDisplayCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "flightDisplayCell", for: indexPath) as? FlightDisplayCell
        if let trips = flightResponse?.trips {
            if let trip = trips[0] as Trip? {
                cell.setupWith(flightDates: trip.dates![indexPath.section].flights!)
            }
        }
        return cell
    }
    
    func showAlert(message: String?) {
        guard message != nil else { return }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
