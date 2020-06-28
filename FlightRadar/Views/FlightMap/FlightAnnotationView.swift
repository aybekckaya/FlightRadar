//
//  FlightAnnotationView.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

#warning("TODO: Gruplamayı burada göster. İçine numara alsın grid için")

//MARK: FlightAnnotationViewDelegate
protocol FlightAnnotationViewDelegate {
    func flightAnnotationViewDidTapped(view:FlightAnnotationView)
}

//MARK: Flight Annotation View
class FlightAnnotationView: MKAnnotationView {
    
    fileprivate var delegate:FlightAnnotationViewDelegate!
    fileprivate(set) var currentState:FlightAnnotationState = .flying
    fileprivate(set) var currentAnnotation:FlightAnnotation!
    
    fileprivate let imViewPlane:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = true
        img.isUserInteractionEnabled = true
        return img
    }()
    
    fileprivate var viewCall:FlightCallView = FlightCallView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Public
extension FlightAnnotationView {
    func setAnnotation(annotation:FlightAnnotation) {
        self.currentAnnotation = annotation
        self.updateUI()
    }
    
    func setDelegate(delegate:FlightAnnotationViewDelegate) {
        self.delegate = delegate
    }
    
    func setState(state:FlightAnnotationState) {
        guard state != self.currentState else { return }
        self.currentState = state
        self.updateUI()
    }
}

//MARK: Set Up / Update UI
extension FlightAnnotationView {
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    fileprivate func setRotationDegree(degree:Double) {
              let radians = deg2rad(degree)
              let rotationDegree:CGFloat = CGFloat(radians)
              self.transform = CGAffineTransform(rotationAngle: rotationDegree)
          }
    
    fileprivate func updateUI() {
        self.viewCall.removeFromSuperview()
        self.setRotationDegree(degree: self.currentAnnotation.rotationDegree)
        switch self.currentState {
            case .flying:
                self.imViewPlane.image = UIImage(named: "Plane")
            case .onTheGround:
                self.imViewPlane.image = UIImage(named: "PlaneGround")
            case .selected:
                self.imViewPlane.image = UIImage(named: "PlaneSelected")!
                self.addCallView()
        }
 
    }
    
    private func addCallView() {
        self.viewCall.removeFromSuperview()
        self.viewCall = FlightCallView()
        self.viewCall.center = self.imViewPlane.center
        self.addSubview(self.viewCall)
        self.viewCall.animate()
        self.bringSubviewToFront(self.imViewPlane)
    }
    
    private func setUpUI() {
        self.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.imViewPlane)
        self.imViewPlane.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.imViewPlane.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        let tapGestureImView = UITapGestureRecognizer(target: self, action: #selector(imViewPlaneDidTapped))
        tapGestureImView.numberOfTouchesRequired = 1
        tapGestureImView.numberOfTapsRequired = 1
        self.imViewPlane.addGestureRecognizer(tapGestureImView)
        
    }
}

//MARK: Actions
extension FlightAnnotationView {
    @objc fileprivate func imViewPlaneDidTapped() {
        self.delegate.flightAnnotationViewDidTapped(view: self)
    }
}
