//
//  Configuration.swift
//  FlightRadar
//
//  Created by aybek can kaya on 29.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit

struct Configuration {
    static let flightReloadTimeInterval:TimeInterval = 5.0
}


// MARK: Font
enum Font:String {
    case Museo100 = "Museo100-Regular"
    case Museo300 = "Museo300-Regular"
    case Museo500 = "Museo500-Regular"
    case Museo700 = "Museo700-Regular"
    case Museo900 = "Museo900-Regular"
    
    func font(size:CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
