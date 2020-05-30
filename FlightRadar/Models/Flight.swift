//
//  Flight.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

class Flight: NSObject {
    fileprivate(set) var latitude:Double = 0
    fileprivate(set) var longitude:Double = 0
    fileprivate(set) var originCountry:String = ""
    fileprivate(set) var isOnGround:Bool = false
    fileprivate(set) var degree:Double = 0
    fileprivate(set) var shouldShowInMap:Bool = true
    
    
    init?(json:JSON) {
        super.init()
        guard let jsonArray:[JSON] = json.array else { return nil }
        guard let latitude:Double = jsonArray[6].double else { return nil }
        guard let longitude:Double = jsonArray[5].double else { return nil }
        guard let originCountry:String = jsonArray[2].string else { return nil }
        guard let isOnGround:Bool = jsonArray[8].bool else { return nil }
        
        self.isOnGround = isOnGround
        self.latitude = latitude
        self.longitude = longitude
        self.originCountry = originCountry
        self.degree = jsonArray[10].double ?? 0
    }
    
    func setShouldShowInMap(show:Bool) {
        self.shouldShowInMap = show
    }
}
