//
//  FlightMapControllerTests.swift
//  FlightRadarTests
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import XCTest
import MapKit
@testable import FlightRadar

class FlightMapControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

extension FlightMapControllerTests {
    func test1AnnotationViewSelection() {
        let mock = FlightMapControllerMock()
        XCTAssert(mock.selectedAnnotationIdentifierMock == nil , "\(mock.selectedAnnotationIdentifierMock) should be nil")
        mock.selectAnnotationViewWithIdentifierMock(identifier: "HelloWorld")
        XCTAssert(mock.selectedAnnotationIdentifierMock != nil , "\(mock.selectedAnnotationIdentifierMock) should not be nil")
        XCTAssert(mock.selectedAnnotationIdentifierMock == "HelloWorld" , "\(mock.selectedAnnotationIdentifierMock) failure")
        mock.selectAnnotationViewWithIdentifierMock(identifier: "Selection2")
        XCTAssert(mock.selectedAnnotationIdentifierMock == "Selection2" , "\(mock.selectedAnnotationIdentifierMock) failure")
        mock.selectAnnotationViewWithIdentifierMock(identifier: "Selection2")
        XCTAssert(mock.selectedAnnotationIdentifierMock == nil , "\(mock.selectedAnnotationIdentifierMock) should be nil")
    }
    
    func test2AnnotationViewIsSelectedCheck() {
        let mock = FlightMapControllerMock()
        var isSelected:Bool = false
        
        isSelected = mock.isAnnotationViewSelectedMock(annIdentifier: "Hello")
        XCTAssert(isSelected == false)
        
        mock.selectAnnotationViewWithIdentifierMock(identifier: "Hello")
        isSelected = mock.isAnnotationViewSelectedMock(annIdentifier: "Hello")
        XCTAssert(isSelected == true)
        
        isSelected = mock.isAnnotationViewSelectedMock(annIdentifier: "Hello1")
               XCTAssert(isSelected == false)

       }
    
    func test3StateForAnnotation() {
        var annotation:FlightAnnotation
        var state:FlightAnnotationState
        let mock = FlightMapControllerMock()
        
        annotation = FlightAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), rotationDegree: 0, icao24: "ica1", state: FlightAnnotationState.flying)
        state = mock.stateForAnnotation(annotation: annotation)
        XCTAssert(state == .flying)
        
        annotation = FlightAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), rotationDegree: 0, icao24: "ica1", state: FlightAnnotationState.flying)
        mock.selectAnnotationViewWithIdentifierMock(identifier: annotation.icao24Identifier)
        state = mock.stateForAnnotation(annotation: annotation)
        XCTAssert(state == .selected)
        
    }
    
}
