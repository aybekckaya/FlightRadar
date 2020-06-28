//
//  FlightVCPresenter.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import SwiftyJSON

//MARK: FlightVC Presenter {Class}
class FlightVCPresenter: NSObject {
    //Private
    fileprivate let bag = DisposeBag()
    fileprivate let gridController = GridController()
   
    fileprivate var timer:Timer?
    fileprivate var mapViewSize:CGSize = CGSize.zero
   
    //Accessibles
    fileprivate(set) var currentFlightAnnotations:[FlightAnnotation] = []
    fileprivate(set) var mapView:FlightMap = FlightMap()
    
    // Rx
    fileprivate(set) var shouldReloadView = BehaviorSubject<Bool>(value: false)
    fileprivate(set) var currentAlertView = BehaviorSubject<FlightAlertModel?>(value: nil)

    override init() {
        super.init()
    }
}

//MARK: Request
extension FlightVCPresenter {
    func requestFlightAnnotations(latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: Configuration.flightReloadTimeInterval, repeats: false, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.requestFlightAnnotations(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax)
        })
        
        self.request(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax).flatMapLatest {[weak self] response -> Observable<[Flight]> in
            guard let strongSelf = self else { return Observable.of([]) }
            if let error = response.error {
                let model = FlightAlertModel(title: "Error", descriptionText: error.localizedDescription)
                strongSelf.currentAlertView.onNext(model)
                strongSelf.currentAlertView.onNext(nil)
                return Observable.of([])
            }
            return strongSelf.convertResponseDataToFlights(data: response.result)
        }.flatMapLatest { arrFlights -> Observable<[FlightAnnotation]> in
            return self.flightsToFlightAnnotations(flights: arrFlights)
        }.subscribe(onNext: { annotations in
            self.currentFlightAnnotations = annotations
            self.shouldReloadView.onNext(true)
            self.shouldReloadView.onNext(false)
        }).disposed(by: self.bag)
    }
    
    private func request(latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double) -> Observable<NetworkResponse> {
        let request = NetworkRequest(route: FlightNetwork.states(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax), parameters: nil)
        return Network.request(request: request)
    }
}

//MARK: Converter
extension FlightVCPresenter {
    fileprivate func convertResponseDataToFlights(data:JSON)->Observable<[Flight]> {
        let flights = data["states"].compactMap { ( _ , json) -> Flight? in
            guard let theFlight = Flight(json: json) else { return nil }
            let shouldShowInMap = FILTER.arrSelectedCountries.contains(theFlight.originCountry) || FILTER.arrSelectedCountries.count == 0
            theFlight.setShouldShowInMap(show: shouldShowInMap)
            theFlight.setPositionInMap(pos: self.mapView.convert(CLLocationCoordinate2D(latitude: theFlight.latitude, longitude: theFlight.longitude), toPointTo: self.mapView))
            return theFlight
        }
        return Observable.of(flights)
    }
    
    fileprivate func flightsToFlightAnnotations(flights:[Flight])-> Observable<[FlightAnnotation]> {
        self.gridController.setFlights(flights: flights.filter{ $0.shouldShowInMap == true }, viewSize: self.mapView.frame.size)
        let arrAnnotations = self.gridController.arrGrids.compactMap { grid -> FlightAnnotation? in
            guard grid.arrFlights.count > 0 else { return nil }
            return FlightAnnotation(arrFlights: grid.arrFlights, coordinate: grid.midCoordinate())
        }
        return Observable.of(arrAnnotations)
    }
    
   
}

//MARK: Public
extension FlightVCPresenter {
    func setMapViewSize(size:CGSize) {
        self.mapViewSize = size 
    }
    
    func getCountryList()->[Country] {
        var setCountryNames = Set<String>()
        self.currentFlightAnnotations.forEach { ann in
            ann.arrFlights.forEach { fl in
                setCountryNames.insert(fl.originCountry)
            }
        }
      
        return Array(setCountryNames).sorted().map { Country(name: $0) }
    }
}


//MARK: Mock
class FlightVCPresenterMock:FlightVCPresenter {
    
}
