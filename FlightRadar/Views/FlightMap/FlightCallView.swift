//
//  FlightCallView.swift
//  FlightRadar
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

//MARK: Flight Annotation Call View
class FlightCallView:UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        self.backgroundColor = UIColor.clear
    }
    
    func animate() {
        let callView:UIView = UIView(frame: CGRect.zero)
        callView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        callView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        callView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.2901960784, blue: 0.4392156863, alpha: 1).withAlphaComponent(1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        self.addSubview(callView)
        
        UIView.animate(withDuration: 5.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            callView.transform = CGAffineTransform(scaleX: 100, y: 100)
            callView.alpha = 0
        }) { _ in
            callView.removeFromSuperview()
            self.animate()
        }
        
    }
}
