//
//  UIViewController+AlertView.swift
//  FlightRadar
//
//  Created by aybek can kaya on 30.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlertView(error:NSError) {
        let userInfo:[String:Any] = error.userInfo
        guard let message:String = userInfo["desc"] as? String else { return }
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
