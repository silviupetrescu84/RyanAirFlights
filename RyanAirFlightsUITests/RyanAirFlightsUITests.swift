//
//  RyanAirFlightsUITests.swift
//  RyanAirFlightsUITests
//
//  Created by Petrescu Silviu on 2/23/20.
//  Copyright © 2020 Petrescu Silviu. All rights reserved.
//

import XCTest

class RyanAirFlightsUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() {
        let app = XCUIApplication()
        app.launch()
        
        app.textFields["DepartureStation"].writeText("Dublin - DUB")
        app.textFields["DestinationStation"].writeText("Athens - ATH")
        app.textFields["DepartureDate"].writeText("2020-20-06")
        XCUIApplication().buttons["Done"].tap()
        app.buttons["SearchButton"].tap()
    }
    
    

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func checkTextExists(_ text: String) -> Bool {
        var textExists = false
        for i in 0 ..< XCUIApplication().staticTexts.count {
            print(XCUIApplication().staticTexts.element(boundBy: i).label)
            if XCUIApplication().staticTexts.element(boundBy: i).label.contains(text) {
                textExists = true
                break
            }
        }
        return textExists
    }
}

extension XCUIElement {
    // Writes the text into a textview
    func writeText(_ text: String) {
        tap()
        typeText(text)
        
    }
}
