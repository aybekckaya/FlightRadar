//
//  FlightsVC.swift
//  FlightRadar
//
//  Created by aybek can kaya on 29.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FlightsVC: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }
    
    fileprivate let bag = DisposeBag()
    
    fileprivate var mapView:FlightMap!
    fileprivate var presenter:FlightVCPresenter = FlightVCPresenter()
    
    fileprivate let btnFilter:UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = #colorLiteral(red: 0.2259458005, green: 0.5810804367, blue: 0.76838094, alpha: 1)
        btn.setImage(UIImage(named: "Filter"), for: UIControl.State.normal)
        return btn
    }()
}

//MARK: LifeCycle
extension FlightsVC  {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           self.setUpUI()
           self.addListeners()
       }
}

//MARK: Listeners
extension FlightsVC {
    fileprivate func addListeners() {
        self.presenter.shouldReloadView.filter{ $0 == true }.subscribe(onNext: { _ in
            self.mapView.addFlightAnnotations(arrFlightAnnotations: self.presenter.currentFlightAnnotations)
        }).disposed(by: self.bag)
        
        self.presenter.currentAlertView.filter{ $0 != nil }.subscribe(onNext: { alertModel in
            self.showAlertViewWithOK(title: alertModel!.title, message: alertModel!.descriptionText)
        }).disposed(by: self.bag)
        
    }
}


//MARK: Set Up
extension FlightsVC {
    fileprivate func setUpUI() {
        self.view.backgroundColor = UIColor.white
        self.mapView = FlightMap(delegate: self)
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.fitIntoSuperView()
        
        self.view.addSubview(self.btnFilter)
        self.btnFilter.activateViewConstraint(constraint: ViewConstraint(top: 16, leading: nil, trailing: -16, bottom: nil, height: 50, width: 50, centerX: nil, centerY: nil), constraintBased: true)
        self.btnFilter.layer.cornerRadius = 25
        self.btnFilter.layer.masksToBounds = true
        self.btnFilter.addTarget(self, action: #selector(filterOnTap), for: UIControl.Event.touchUpInside)
        
    }
}

//MARK: Actions
extension FlightsVC {
    @objc private func filterOnTap() {
        let countries = self.presenter.getCountryList()
        let vc:FilterVC = FilterVC()
        vc.setDependency(arrCountries: countries)
        let navCon = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navCon, animated: true, completion: nil)
    }
}


//MARK: FlightMap Delegate
extension FlightsVC  : FlightMapDelegate {
    func flightMapDidChangedRegion(map: FlightMap, latitudeMin: Double, latitudeMax: Double, longitudeMin: Double, longitudeMax: Double) {
        self.presenter.requestFlightAnnotations(latitudeMin: latitudeMin, latitudeMax: latitudeMax, longitudeMin: longitudeMin, longitudeMax: longitudeMax)
    }
}
