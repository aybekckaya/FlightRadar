//
//  FlightAnnotation.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

//MARK: FlightAnnotationViewState
enum FlightAnnotationState {
    case unknown
    case flying
    case onTheGround
    case selected
}

class FlightAnnotation: NSObject,MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    
    fileprivate(set) var rotationDegree:Double = 0
    fileprivate(set) var icao24Identifier:String = ""
    fileprivate(set) var currentState:FlightAnnotationState = .flying
    //fileprivate(set) var flight:Flight!
    fileprivate(set) var arrFlights:[Flight] = []
    
    /*
    init(flight:Flight) {
        self.coordinate = CLLocationCoordinate2D(latitude: flight.latitude, longitude: flight.longitude)
        super.init()
        self.flight = flight
        self.currentState = self.getState()
        self.icao24Identifier = self.flight.icao24
        self.rotationDegree = self.flight.degree
    }
    */
    init(arrFlights:[Flight] , coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
        self.arrFlights = arrFlights
        if arrFlights.count == 1 {
            let fl = arrFlights.first!
            self.currentState = self.getState()
            self.icao24Identifier = fl.icao24
            self.rotationDegree = fl.degree
        }
    }
    
    
    fileprivate func getState()->FlightAnnotationState {
        guard self.arrFlights.count == 1 else { return .unknown }
        if self.arrFlights.first!.isOnGround == true {
            return .onTheGround
        }
        else if self.arrFlights.first!.isOnGround == false {
            return .flying
        }
        return .flying
    }
}
