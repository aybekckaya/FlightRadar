//
//  FlightMapCoordinatesTests.swift
//  FlightRadarTests
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import XCTest
import MapKit
@testable import FlightRadar

class FlightMapCoordinatesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

extension FlightMapCoordinatesTests {
    func test1BoundariesSet() {
        let mock = FlightMapCoordinatesMock()
        mock.setBoundariesMock(nw: CLLocationCoordinate2D(latitude: 10, longitude: -10), ne: CLLocationCoordinate2D(latitude: 10, longitude: 10), se: CLLocationCoordinate2D(latitude: -10, longitude: 10), sw: CLLocationCoordinate2D(latitude: -10, longitude: -10))
        XCTAssert(mock.latitudeMin == -10)
        XCTAssert(mock.latitudeMax == 10 )
        XCTAssert(mock.longitudeMax == 10 )
        XCTAssert(mock.longitudeMin == -10)
    }
}
