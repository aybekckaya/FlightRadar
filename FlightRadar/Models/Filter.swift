//
//  Filter.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

let FILTER = FlightFilter()

class FlightFilter: NSObject {
    fileprivate(set) var arrSelectedCountries:[String] = []
    
    func addCountryToSelectedItems(countryName:String) {
        guard arrSelectedCountries.contains(countryName) == false else { return }
        self.arrSelectedCountries.append(countryName)
    }
    
    func removeCountry(countryName:String) {
        let newArr:[String] = self.arrSelectedCountries.filter { str -> Bool in
            return str != countryName
        }
        self.arrSelectedCountries = newArr
    }
    
    func clearSelectedCities() {
        self.arrSelectedCountries = []
    }
}


