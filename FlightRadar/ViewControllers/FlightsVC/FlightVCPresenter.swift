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

//MARK: Flight VC Presenter Delegate 
protocol FlightVCPresenterDelegate {
    func flightVCPresenterShouldShowErrorAlert(presenter:FlightVCPresenter , error:NSError)
    func flightVCPresenterShouldReloadItems(presenter:FlightVCPresenter , items:[Flight])
}


//MARK: FlightVC Presenter {Class}
class FlightVCPresenter: NSObject {
    fileprivate let bag = DisposeBag()
    fileprivate(set) var currentFlights:[Flight] = []
    fileprivate var delegate:FlightVCPresenterDelegate!
    fileprivate var timer:Timer?

    init(delegate:FlightVCPresenterDelegate) {
        super.init()
        self.delegate = delegate
    }
}

//MARK: Request
extension FlightVCPresenter {
    func request(latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double) {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.request(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax)
        })
        let request = NetworkRequest(route: FlightNetwork.states(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax), parameters: nil)
        
        Network.request(request: request).flatMapLatest { response -> Observable<Bool> in
            if let error = response.error {
                self.delegate.flightVCPresenterShouldShowErrorAlert(presenter: self, error: error)
                return Observable.of(true)
            }
            
            let flights = response.result["states"].compactMap { ( _ , json) -> Flight? in
                guard let theFlight = Flight(json: json) else { return nil }
                let shouldShowInMap = FILTER.arrSelectedCountries.contains(theFlight.originCountry) || FILTER.arrSelectedCountries.count == 0
                theFlight.setShouldShowInMap(show: shouldShowInMap)
                return theFlight
            }
            
            self.currentFlights = flights
            self.delegate.flightVCPresenterShouldReloadItems(presenter: self, items: self.currentFlights)
            
            return Observable.of(true)
        }.subscribe(onNext: { _ in
            
        }).disposed(by: self.bag)
    
    }
}

//MARK: Converter
extension FlightVCPresenter {
    func flightsToFlightAnnotations(flights:[Flight])->[FlightAnnotation] {
        return flights.compactMap { fl -> FlightAnnotation? in
            guard fl.shouldShowInMap == true else { return nil }
            let state:FlightAnnotationState = fl.isOnGround == true ? .onTheGround : .flying
            return FlightAnnotation(coordinate: CLLocationCoordinate2D(latitude: fl.latitude, longitude: fl.longitude), rotationDegree: fl.degree, icao24: fl.icao24, state: state)
        }
    }
    
    func countriesFromFlights(flights:[Flight]) -> [Country] {
        var setCountryNames = Set<String>()
        flights.forEach { fl in
            setCountryNames.insert(fl.originCountry)
        }
        let flightCountryNames:[String] = Array(setCountryNames).sorted()
        
        return flightCountryNames.map { str -> Country in
            return Country(name: str)
        }
    }
}


//MARK: Mock
class FlightVCPresenterMockDelegate:FlightVCPresenterDelegate {
    func flightVCPresenterShouldShowErrorAlert(presenter: FlightVCPresenter, error: NSError) {
        
    }
    
    func flightVCPresenterShouldReloadItems(presenter: FlightVCPresenter, items: [Flight]) {
        
    }
    
    
}


class FlightVCPresenterMock:FlightVCPresenter {
    func flightsToFlightAnnotationsMock(flights:[Flight])->[FlightAnnotation] {
        return super.flightsToFlightAnnotations(flights: flights)
    }
    
    func countriesFromFlightsMock(flights:[Flight]) -> [Country] {
        return super.countriesFromFlights(flights: flights)
    }
}
