//
//  FlightMapCoordinates.swift
//  FlightRadar
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

//MARK: Flight Map Coordinates
class FlightMapCoordinates: NSObject {
    fileprivate(set) var latitudeMin:Double = 0
    fileprivate(set) var latitudeMax:Double = 0
    fileprivate(set) var longitudeMin:Double = 0
    fileprivate(set) var longitudeMax:Double = 0
    
    
    override init() {
        super.init()
    }
    
    func setBoundaries(nw:CLLocationCoordinate2D , ne:CLLocationCoordinate2D , se:CLLocationCoordinate2D , sw:CLLocationCoordinate2D) {
        self.latitudeMin = se.latitude
        self.latitudeMax = ne.latitude
        self.longitudeMin = nw.longitude
        self.longitudeMax = ne.longitude
    }
}

//MARK: FlightMapCoordinatesMock
class FlightMapCoordinatesMock:FlightMapCoordinates {
    func setBoundariesMock(nw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D, se: CLLocationCoordinate2D, sw: CLLocationCoordinate2D) {
        super.setBoundaries(nw: nw, ne: ne, se: se, sw: sw)
    }
}



