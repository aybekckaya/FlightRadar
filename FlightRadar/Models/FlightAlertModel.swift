//
//  FlightAlertModel.swift
//  FlightRadar
//
//  Created by aybek can kaya on 28.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation

struct FlightAlertModel {
    let title:String
    let descriptionText:String
    
    init(title:String , descriptionText:String) {
        self.title = title
        self.descriptionText = descriptionText
    }
}
