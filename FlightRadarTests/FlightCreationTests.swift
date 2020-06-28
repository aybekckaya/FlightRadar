//
//  FlightCreationTests.swift
//  FlightRadarTests
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import FlightRadar

class FlightCreationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

extension FlightCreationTests {
    func test1CreateFlightsFromJson() {
        let path = Bundle.main.path(forResource: "FakeData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data : data)
        let jsonArray:[JSON] = json["states"].arrayValue
        var element:JSON
        var flight:Flight?
        
        // origin_country is null
        element = jsonArray[0]
        flight = Flight(json: element)
        XCTAssert(flight == nil , "Flight should be nil")
        
        // icao24 string is null
        element = jsonArray[1]
        flight = Flight(json: element)
        XCTAssert(flight == nil , "Flight should be nil")
        
        // latitude is null
        element = jsonArray[2]
        flight = Flight(json: element)
        XCTAssert(flight == nil , "Flight should be nil")
        
        // on_ground is null
        element = jsonArray[3]
        flight = Flight(json: element)
        XCTAssert(flight == nil , "Flight should be nil")
        
        // everything OK
        element = jsonArray[4]
        flight = Flight(json: element)
        XCTAssert(flight != nil , "Flight should Not be nil")
    }
    
    func test2CheckFlightParameters() {
        let path = Bundle.main.path(forResource: "FakeData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data : data)
        let jsonArray:[JSON] = json["states"].arrayValue
        var element:JSON
        var flight:Flight?
        
        element = jsonArray[4]
        flight = Flight(json: element)
        XCTAssert(flight!.icao24 == "4b51f0")
        XCTAssert(flight!.latitude == 47.2719)
        XCTAssert(flight!.longitude == 8.3881)
        XCTAssert(flight!.altitude == nil)
        XCTAssert(flight!.isOnGround == false)
        XCTAssert(flight!.velocity == 28.39)
        
    }
    
    func test3ConvertFlightsToFlightAnnotations() {
        let path = Bundle.main.path(forResource: "FakeData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data : data)
        let jsonArray:[JSON] = json["states"].arrayValue
        var element:JSON
        var flight:Flight?
        var annotations:[FlightAnnotation] = []
        let mock = FlightVCPresenterMock(delegate: FlightVCPresenterMockDelegate())
        
        element = jsonArray[4]
        flight = Flight(json: element)
        annotations = mock.flightsToFlightAnnotationsMock(flights: [flight!])
        XCTAssert(annotations.count > 0 , "At least 1 annotation needed")
        
        element = jsonArray[4]
        flight = Flight(json: element)
        flight?.setShouldShowInMap(show: false)
        annotations = mock.flightsToFlightAnnotationsMock(flights: [flight!])
        XCTAssert(annotations.count == 0 , "There should be no annotations")
    }
    
    func test4ExportingCountryNamesCorrectly() {
        let path = Bundle.main.path(forResource: "FakeData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let json = try! JSON(data : data)
        let jsonArray:[JSON] = json["states"].arrayValue
        var element:JSON
        var flight:Flight?
        var countries:[Country] = []
        let mock = FlightVCPresenterMock(delegate: FlightVCPresenterMockDelegate())
        
        element = jsonArray[4]
        flight = Flight(json: element)
        countries = mock.countriesFromFlights(flights: [flight!])
        XCTAssert(countries.first!.name == "Switzerland")
        
        countries = mock.countriesFromFlights(flights: [  Flight(json: jsonArray[5])!   , Flight(json: jsonArray[4])! ])
        XCTAssert(countries.first!.name == "Switzerland")
        XCTAssert(countries[1].name == "Turkey")
    }
}


