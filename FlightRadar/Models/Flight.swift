//
//  Flight.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class Flight: NSObject {
    fileprivate(set) var icao24:String = ""
    fileprivate(set) var latitude:Double = 0
    fileprivate(set) var longitude:Double = 0
    fileprivate(set) var originCountry:String = ""
    fileprivate(set) var isOnGround:Bool = false
    fileprivate(set) var degree:Double = 0
    fileprivate(set) var shouldShowInMap:Bool = true
    fileprivate(set) var callSign:String?
    fileprivate(set) var altitude:Double?
    fileprivate(set) var velocity:Double?
    
    
    init?(json:JSON) {
        super.init()
        guard let jsonArray:[JSON] = json.array else { return nil }
        guard let latitude:Double = jsonArray[6].double else { return nil }
        guard let longitude:Double = jsonArray[5].double else { return nil }
        guard let originCountry:String = jsonArray[2].string else { return nil }
        guard let isOnGround:Bool = jsonArray[8].bool else { return nil }
        guard let icao:String = jsonArray[0].string else { return nil }
        
        self.isOnGround = isOnGround
        self.latitude = latitude
        self.longitude = longitude
        self.originCountry = originCountry
        self.degree = jsonArray[10].double ?? 0
        self.icao24 = icao
        
        if let vl = jsonArray[9].double {
            self.velocity = vl
        }
        
        if let sign = jsonArray[1].string {
            self.callSign = sign
        }
        
        if let alt = jsonArray[7].double {
            self.altitude = alt 
        }
    }
    
    func setShouldShowInMap(show:Bool) {
        self.shouldShowInMap = show
    }
}
