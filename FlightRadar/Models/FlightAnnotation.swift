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
    case flying
    case onTheGround
    case selected
}

class FlightAnnotation: NSObject,MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    
    fileprivate(set) var rotationDegree:Double = 0
    fileprivate(set) var icao24Identifier:String = ""
    fileprivate(set) var currentState:FlightAnnotationState = .flying
    
    init(coordinate:CLLocationCoordinate2D , rotationDegree:Double , icao24:String , state:FlightAnnotationState) {
        self.coordinate = coordinate
        super.init()
        self.currentState = state 
        self.rotationDegree = rotationDegree
        self.icao24Identifier = icao24
    }
}
