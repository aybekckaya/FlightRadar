//
//  FlightAnnotation.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

class FlightAnnotation: NSObject,MKAnnotation  {
    var coordinate: CLLocationCoordinate2D
    fileprivate(set) var isOnGround:Bool = true
    fileprivate(set) var rotationDegree:Double = 0
    
    init(coordinate:CLLocationCoordinate2D , isOnTheGround:Bool , rotationDegree:Double) {
        self.coordinate = coordinate
        super.init()
        self.isOnGround = isOnTheGround
        self.rotationDegree = rotationDegree
    }
}
