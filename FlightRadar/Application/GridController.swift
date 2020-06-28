//
//  GridController.swift
//  FlightRadar
//
//  Created by aybek can kaya on 28.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: Grid Class
class Grid {
    var originPoint:CGPoint = .zero
    var size:CGSize = .zero
    var arrFlights:[Flight] = []
    
    func midCoordinate()->CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.arrFlights.reduce(0, { (res, fl) -> Double in
            return res + fl.latitude
        }) / Double(self.arrFlights.count) , longitude: self.arrFlights.reduce(0, { (res, fl) -> Double in
            return res + fl.longitude
        }) / Double(self.arrFlights.count))
    }
}

//MARK: Controller
class GridController: NSObject {
    static let cellEdgeLength:CGFloat = 50
    fileprivate var arrFlights:[Flight] = []
    fileprivate var viewSize:CGSize = .zero
    
    fileprivate(set) var arrGrids:[Grid] = []
    
    override init() {
        super.init()
    }
}

//MARK: Public
extension GridController {
    func setFlights(flights:[Flight] , viewSize:CGSize) {
        self.arrFlights = flights
        self.viewSize = viewSize
        self.insertFlightsToGrids()
    }
}

//MARK: Core
extension GridController {
    fileprivate func makeGrids() {
        self.arrGrids = []
        for xPos in stride(from: 0, to: viewSize.width, by: GridController.cellEdgeLength) {
            for yPos in stride(from: 0, to: viewSize.height, by: GridController.cellEdgeLength) {
                let origin = CGPoint(x: xPos, y: yPos)
                let grid = Grid()
                grid.originPoint = origin
                grid.size = CGSize(width: GridController.cellEdgeLength, height: GridController.cellEdgeLength)
                self.arrGrids.append(grid)
            }
        }
    }
    
    fileprivate func insertFlightsToGrids() {
        self.makeGrids()
        self.arrFlights.forEach { fl in
            self.insertFlight(flight: fl)
        }
    }
    
    fileprivate func insertFlight(flight:Flight) {
        guard let gridAppropriate = self.appropriateGridForLocation(position: flight.position) else { return }
        gridAppropriate.arrFlights.append(flight)
    }
    
    fileprivate func appropriateGridForLocation(position:CGPoint) -> Grid? {
        let rect = CGRect(origin: CGPoint.zero, size: self.viewSize)
        guard rect.contains(position) else { return nil }
        for index in 0 ..< self.arrGrids.count {
            let rect = CGRect(origin: self.arrGrids[index].originPoint, size: self.arrGrids[index].size)
            if rect.contains(position) {
                return self.arrGrids[index]
            }
        }
        return nil
    }
}


