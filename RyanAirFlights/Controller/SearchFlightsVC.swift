//
//  SearchFlightsVC.swift
//  RyanAirFlights
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import Foundation
import UIKit

class SearchFlightsVC: UIViewController {
    
    let departureDatePicker : UIDatePicker = UIDatePicker()
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var departureStation: SearchTextField!
    @IBOutlet weak var destinationStation: SearchTextField!
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var adultsLabel: UILabel!
    @IBOutlet weak var teenLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    
    
    override func viewDidLoad() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDatePickerPressed))
        
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        departureDate.inputAccessoryView = toolBar

    
        departureDatePicker.datePickerMode = .date
        departureDate.inputView = departureDatePicker
        departureDatePicker.addTarget(self, action: #selector(onDatePickerValueChanged(datePicker:)), for: UIControl.Event.valueChanged)
        
        downloadStations()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func downloadStations() {
        APIService.shared.getStations { (error, stationsResponse) in
            if error == nil {
                if let currentStationsResonse = stationsResponse as? StationsResponse {
                    if let currentStations = currentStationsResonse.stations {
                        GlobalData.shared.stations = currentStations
                    }
                }
            } else { //To do create a main view which displays errors in a queue
                self.showAlert(message: error?.localizedDescription)
            }
            DispatchQueue.main.async {
                self.endLoadingStations()
            }
        }
    }
    
    func endLoadingStations() {
        activityIndicator.stopAnimating()
        showForm()
    }
    
    func showForm() {
        var stationNames = [String]()
        //This should be done better to keep an identifier, for now we assume the code is Unique
        for station in GlobalData.shared.stations {
            if station.name == nil { continue }
            if station.code == nil { continue }
            stationNames.append(station.name! + " - " + station.code!)
        }
        departureStation.startVisible = true
        departureStation.filterStrings(stationNames)
        departureStation.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
        departureStation.startVisible = true
        destinationStation.filterStrings(stationNames)
        destinationStation.theme.bgColor = UIColor (red: 1, green: 1, blue: 1, alpha: 1)
        
        formView.isHidden = false
    }
    
    @IBAction func adultsStepperChanged(_ sender: Any) {
        if let currentSender = sender as? UIStepper {
            adultsLabel.text = String(Int(currentSender.value))
        }
    }
    @IBAction func teenStepperChanged(_ sender: Any) {
        if let currentSender = sender as? UIStepper {
            teenLabel.text = String(Int(currentSender.value))
        }
    }
    @IBAction func childrenStepperChanged(_ sender: Any) {
        if let currentSender = sender as? UIStepper {
            childrenLabel.text = String(Int(currentSender.value))
        }
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        if validateAll() {
            performSegue(withIdentifier: "showFlights", sender: nil)
        }
    }
    
    @objc func doneDatePickerPressed(){
        self.view.endEditing(true)
    }
    
    @objc func onDatePickerValueChanged(datePicker: UIDatePicker) {
        departureDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    func validateAll() -> Bool {
        guard departureStation.text != "" else { showAlert(message: "Please enter a departure station"); return false}
        guard GlobalData.shared.stations.checkStationExists(string: departureStation.text ?? "") else { showAlert(message: "Selected departure station does not exist"); return false }
        guard destinationStation.text != "" else { showAlert(message: "Please enter a destination station"); return false}
        guard GlobalData.shared.stations.checkStationExists(string: departureStation.text ?? "") else { showAlert(message: "Selected destination station does not exist"); return false }
        guard departureStation.text != destinationStation.text else { showAlert(message: "Destination must be different than departure"); return false }
        guard departureDate.text != "" else { showAlert(message: "Please select a departure date"); return false}
        //Should be prevented by UI, making sure the stepper validation doesn't fail
        guard Int(adultsLabel.text ?? "0") ?? 0 >= 1 else { showAlert(message: "At least 1 adult needs to be selected"); return false}
        guard Int(adultsLabel.text ?? "0") ?? 0 <= 6 else { showAlert(message: "At most 6 adults can be selected"); return false}
        guard Int(teenLabel.text ?? "0") ?? 0 >= 0 else { showAlert(message: "The number of teens cannot be negative"); return false}
        guard Int(teenLabel.text ?? "0") ?? 0 <= 6 else { showAlert(message: "At most 6 teens can be selected"); return false}
        guard Int(childrenLabel.text ?? "0") ?? 0 >= 0 else { showAlert(message: "The number of children cannot be negative"); return false}
        guard Int(childrenLabel.text ?? "0") ?? 0 <= 6 else { showAlert(message: "At most 6 children can be selected"); return false}
        
        return true
    }
    
    func generateParameters() -> [String: String] {
        var parameters = [String: String]()
        if let departureStation = GlobalData.shared.stations.getStation(string: departureStation.text ?? "") {
            parameters["origin"] = departureStation.code ?? ""
        }
        if let destinationStation = GlobalData.shared.stations.getStation(string: departureStation.text ?? "") {
            parameters["destination"] = destinationStation.code ?? ""
        }
        parameters["dateout"] = departureDate.text ?? ""
        parameters["datein"] = "" //Not set, needs a new textfield for return dates
        parameters["flexdaysbeforeout"] = "3" //Set here, but should be textfield for how many flexible dates the user wants to see
        parameters["flexdaysout"] = "3" //Set here, but should be textfield for how many flexible dates the user wants to see
        parameters["flexdaysin"] = "3" //Set here, but should be textfield for how many flexible dates the user wants to see
        parameters["adt"] = adultsLabel.text ?? "0"
        parameters["teen"] = teenLabel.text ?? "0"
        parameters["chd"] = childrenLabel.text ?? "0"
        parameters["roundtrip"] = "false" //Should have a field on UI
        
        return parameters
    }
    
    func showAlert(message: String?) {
        guard message != nil else { return }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFlights":
            if let vc = segue.destination as? ShowFlightsVC {
                vc.parameters = self.generateParameters()
            }
        default:
            return
        }
    }
}

