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

//MARK: Flight Map Delegate
protocol FlightMapDelegate {
    func flightMapDidChangedRegion(map:FlightMap , latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double)
}


//MARK: FlightMap {Class}
class FlightMap: MKMapView {
    fileprivate var mapDelegate:FlightMapDelegate!
    
    init(delegate:FlightMapDelegate) {
        super.init(frame: CGRect.zero)
        self.delegate = self
        self.mapDelegate = delegate
        
        self.register(FlightAnnotationView.self, forAnnotationViewWithReuseIdentifier: "FlightAnnotationView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: MapView Delegate
extension FlightMap:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Selected Ann : \(view)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //return nil
        guard let annView:FlightAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "FlightAnnotationView", for: annotation) as? FlightAnnotationView, let ann:FlightAnnotation = annotation as? FlightAnnotation else { return nil }
        annView.setIsOnTheGround(onTheGround: ann.isOnGround)
        annView.setRotationDegree(degree: ann.rotationDegree)
        return annView
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Current Region : \(mapView.region)")
        self.mapDelegate.flightMapDidChangedRegion(map: self, latitudeMin: self.southEastCoordinate.latitude, latitudeMax: self.northEastCoordinate.latitude, longitudeMin: self.southWestCoordinate.longitude, longitudeMax: self.southEastCoordinate.longitude)
    }
}

//MARK: Bounding Coordinates
extension FlightMap {
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

//MARK: Public Methods
extension FlightMap {
    func addFlightAnnotations(arrFlightAnnotations:[FlightAnnotation]) {
        self.removeAnnotations(self.annotations)
        self.addAnnotations(arrFlightAnnotations)
    }
}


