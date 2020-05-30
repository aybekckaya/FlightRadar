//
//  Country.swift
//  FlightRadar
//
//  Created by aybek can kaya on 29.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

class Country: NSObject , ItemPresentable {
    fileprivate(set) var name:String
    
    init(name:String) {
        self.name = name
        super.init()
       
    }
    
}
