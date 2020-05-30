//
//  FlightNetwork.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation

enum FlightNetwork {
    case states(latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double)
}

extension FlightNetwork:NetworkRoute {
    var url: String {
           switch self {
               case .states(let latitudeMin, let latitudeMax, let longitudeMin, let longitudeMax):
                   return "https://aybekcankaya:ackack123@opensky-network.org/api/states/all?lamin=\(latitudeMin)&lomin=\(longitudeMin)&lamax=\(latitudeMax)&lomax=\(longitudeMax)"
           }
       }
       
       var method: RequestMethod {
           return RequestMethod.get
       }
}
