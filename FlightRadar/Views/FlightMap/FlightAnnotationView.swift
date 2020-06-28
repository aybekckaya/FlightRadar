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
    
    fileprivate enum FlightAnnotationViewType {
        case plane
        case grouped
    }
    
    fileprivate var type:FlightAnnotationViewType = .plane
    fileprivate var delegate:FlightAnnotationViewDelegate!
    fileprivate var viewCall:FlightCallView = FlightCallView()
    
    fileprivate(set) var currentState:FlightAnnotationState = .flying
    fileprivate(set) var currentAnnotation:FlightAnnotation!
   
    fileprivate let lblCount:UILabel = {
        let lbl = UILabel(frame: CGRect.zero)
        lbl.translatesAutoresizingMaskIntoConstraints = true
        lbl.font = Font.Museo700.font(size: 12)
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
    
    fileprivate let imViewPlane:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = true
        img.isUserInteractionEnabled = true
        return img
    }()
    

    
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
        self.type = self.currentAnnotation.arrFlights.count == 1 ? .plane : .grouped
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
        self.frame = self.type == FlightAnnotationViewType.plane ? CGRect(x: 0, y: 0, width: 64, height: 64) : CGRect(x: 0, y: 0, width: 24, height: 24)
        switch self.type {
        
        case .plane:
            self.setRotationDegree(degree: self.currentAnnotation.rotationDegree)
            switch self.currentState {
                case .flying:
                    self.imViewPlane.image = UIImage(named: "Plane")
                case .onTheGround:
                    self.imViewPlane.image = UIImage(named: "PlaneGround")
                case .selected:
                    self.imViewPlane.image = UIImage(named: "PlaneSelected")!
                    self.addCallView()
            case .unknown:
                break
            }
            self.lblCount.removeFromSuperview()
            self.backgroundColor = UIColor.clear
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = true
        
        case .grouped:
            self.lblCount.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
            self.imViewPlane.removeFromSuperview()
            self.backgroundColor = UIColor.red
            self.layer.cornerRadius = self.frame.size.width / 2
            self.layer.masksToBounds = true
            self.lblCount.text = "\(self.currentAnnotation.arrFlights.count)"
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
        self.frame = self.type == FlightAnnotationViewType.plane ? CGRect(x: 0, y: 0, width: 64, height: 64) : CGRect(x: 0, y: 0, width: 24, height: 24)
        self.backgroundColor = UIColor.clear
        self.addSubview(self.imViewPlane)
        self.imViewPlane.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.imViewPlane.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        self.addSubview(self.lblCount)
        self.lblCount.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        
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
