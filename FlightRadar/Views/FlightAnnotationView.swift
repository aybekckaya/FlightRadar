//
//  FlightAnnotationView.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit
import MapKit

class FlightAnnotationView: MKAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: Setters
extension FlightAnnotationView {
    func setIsOnTheGround(onTheGround:Bool) {
        self.image = onTheGround == true ? UIImage(named: "PlaneGround") : UIImage(named: "Plane")
        self.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    func setRotationDegree(degree:Double) {
        let radians = deg2rad(degree)
        let rotationDegree:CGFloat = CGFloat(radians)
        self.transform = CGAffineTransform(rotationAngle: rotationDegree)
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

//MARK: Set Up UI
extension FlightAnnotationView {
    private func setUpUI() {
        self.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
}
