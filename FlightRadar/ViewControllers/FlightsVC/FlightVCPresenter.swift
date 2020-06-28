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
   
    fileprivate var timer:Timer?
    
    //Accessibles
    fileprivate(set) var currentFlightAnnotations:[FlightAnnotation] = []
    
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
    
    func request(latitudeMin:Double , latitudeMax:Double , longitudeMin:Double , longitudeMax:Double) -> Observable<NetworkResponse> {
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
            return theFlight
        }
        return Observable.of(flights)
    }
    
    fileprivate func flightsToFlightAnnotations(flights:[Flight])-> Observable<[FlightAnnotation]> {
        return Observable.of(flights.compactMap { fl -> FlightAnnotation? in
            guard fl.shouldShowInMap == true else { return nil }
            return FlightAnnotation(flight: fl)
        })
    }
    
   
}

//MARK: Public
extension FlightVCPresenter {
    
    func getCountryList()->[Country] {
        var setCountryNames = Set<String>()
        self.currentFlightAnnotations.compactMap{ $0.flight }.forEach { fl in
            setCountryNames.insert(fl.originCountry)
        }
        return Array(setCountryNames).sorted().map { Country(name: $0) }
    }
}


//MARK: Mock
class FlightVCPresenterMock:FlightVCPresenter {
    
}
