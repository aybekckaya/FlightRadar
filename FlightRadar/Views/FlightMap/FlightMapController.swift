//
//  FlightMapController.swift
//  FlightRadar
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

class FlightMapController: NSObject {
     fileprivate var selectedAnnotationIdentifier:String? = nil 
     fileprivate(set) var currentCoordinates:FlightMapCoordinates = FlightMapCoordinates()

}

//MARK: Public Methods
extension FlightMapController {
    func updateMapCoordinates(mapView: FlightMap) {
        self.currentCoordinates.setBoundaries(nw: mapView.northWestCoordinate, ne: mapView.northEastCoordinate, se: mapView.southEastCoordinate, sw: mapView.southWestCoordinate)
    }
    
    func selectAnnotationViewWithIdentifier(identifier:String) {
        self.selectedAnnotationIdentifier = self.selectedAnnotationIdentifier == identifier ? nil : identifier
    }
    
    func stateForAnnotation(annotation:FlightAnnotation)->FlightAnnotationState {
        if self.isAnnotationViewSelected(annIdentifier: annotation.icao24Identifier) {
            return FlightAnnotationState.selected
        }
        return annotation.currentState
    }
}

//MARK: Annotation View Selection
extension FlightMapController {
    fileprivate func isAnnotationViewSelected(annIdentifier:String)->Bool {
        guard let identifier = selectedAnnotationIdentifier else { return false }
        return identifier == annIdentifier
    }
}


//MARK: Bounding Coordinates
fileprivate extension FlightMap {
    var northWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.minY).coordinate
    }

    var northEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.minY).coordinate
    }

    var southEastCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.maxY).coordinate
    }

    var southWestCoordinate: CLLocationCoordinate2D {
        return MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.maxY).coordinate
    }
}


//MARK: Flight Controller Mock
class FlightMapControllerMock:FlightMapController {
    var selectedAnnotationIdentifierMock: String? {
        return super.selectedAnnotationIdentifier
    }
    
    func selectAnnotationViewWithIdentifierMock(identifier: String) {
        super.selectAnnotationViewWithIdentifier(identifier: identifier)
    }
    
    func isAnnotationViewSelectedMock(annIdentifier: String) -> Bool {
        return super.isAnnotationViewSelected(annIdentifier: annIdentifier)
    }
    
    func stateForAnnotationMock(annotation: FlightAnnotation) -> FlightAnnotationState {
        return super.stateForAnnotation(annotation: annotation)
    }
    
}
