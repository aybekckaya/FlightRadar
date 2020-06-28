//
//  FlightMap.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxCocoa
import RxSwift

//MARK: Flight Map Delegate
/*
protocol FlightMapDelegate {
    func flightMapDidChangedRegion(map:FlightMap , latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double)
}
*/


//MARK: FlightMap {Class}
class FlightMap: MKMapView {
    fileprivate let bag = DisposeBag()
    fileprivate let controller:FlightMapController = FlightMapController()
    
    fileprivate(set) var currentRegion = BehaviorSubject<FlightMapRegion?>(value: nil)
    
    init() {
        super.init(frame: CGRect.zero)
        self.register(FlightAnnotationView.self, forAnnotationViewWithReuseIdentifier: "FlightAnnotationView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: MapView Delegate
extension FlightMap:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annView:FlightAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "FlightAnnotationView", for: annotation) as? FlightAnnotationView, let ann:FlightAnnotation = annotation as? FlightAnnotation else { return nil }
        annView.setDelegate(delegate: self)
        annView.setAnnotation(annotation: ann)
        let currentState = self.controller.stateForAnnotation(annotation: ann)
        annView.setState(state: currentState)
        return annView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.controller.updateMapCoordinates(mapView: self)
        let boundaries:FlightMapCoordinates = self.controller.currentCoordinates
        self.currentRegion.onNext(FlightMapRegion(latiMin: boundaries.latitudeMin, latiMax: boundaries.latitudeMax, longiMin: boundaries.longitudeMin, longiMax: boundaries.longitudeMax))
        self.currentRegion.onNext(nil)
    }
}


// MARK: Flight Annotation View Delegate
extension FlightMap : FlightAnnotationViewDelegate {
    func flightAnnotationViewDidTapped(view: FlightAnnotationView) {
        #warning("TODO: View Tapped Ekle !!! ")
        return
        self.controller.selectAnnotationViewWithIdentifier(identifier: view.currentAnnotation.icao24Identifier)
        self.addFlightAnnotations(arrFlightAnnotations: self.annotations.compactMap({ ann -> FlightAnnotation? in
            return ann as? FlightAnnotation
        }))
    }
}


//MARK: Public Methods
extension FlightMap {
    func addFlightAnnotations(arrFlightAnnotations:[FlightAnnotation]) {
        self.removeAnnotations(self.annotations)
        self.addAnnotations(arrFlightAnnotations)
    }
}



