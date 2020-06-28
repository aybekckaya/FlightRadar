//
//  FlightMapRegion.swift
//  FlightRadar
//
//  Created by aybek can kaya on 28.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation

struct FlightMapRegion {
    let latitudeMin:Double
    let latitudeMax:Double
    let longitudeMin:Double
    let longitudeMax:Double
    
    init(latiMin : Double , latiMax:Double , longiMin:Double , longiMax:Double) {
        self.latitudeMax = latiMax
        self.latitudeMin = latiMin
        self.longitudeMin = longiMin
        self.longitudeMax = longiMax
    }
}
