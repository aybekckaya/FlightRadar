//
//  UINib+loading.swift
//  FlightRadar
//
//  Created by aybek can kaya on 6.06.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import Foundation
import UIKit


protocol ComponentIdentifier: class {
    static var identifier: String { get }
}

extension ComponentIdentifier {
    static var identifier: String { return String(describing: self) }
}


extension UIView {
    class func loadNib<G: ComponentIdentifier>() -> G {
        guard let view = Bundle.main.loadNibNamed(G.identifier, owner: nil, options: nil)?[0] as? G else { fatalError() }
        return view
    }
}

extension UITableView {
    func deque<G: ComponentIdentifier>(indexPath: IndexPath) -> G {
        guard let cell = self.dequeueReusableCell(withIdentifier: G.identifier, for: indexPath) as? G else { fatalError() }
        return cell
    }
}


extension UICollectionView {
    func deque<G: ComponentIdentifier>(indexPath: IndexPath) -> G {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: G.identifier, for: indexPath) as? G else { fatalError() }
        return cell
    }
    
    func dequeHeaderView<G: ComponentIdentifier>(indexPath:IndexPath)->G {
        guard let view = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: G.identifier, for: indexPath) as? G else { fatalError() }
        return view
    }
}

protocol ControllerNibProtocol {
    static var identifier:String { get }
}

extension ControllerNibProtocol {
    static var identifier: String { return String(describing: self) }
}


extension UIView: ComponentIdentifier {}
extension UIViewController:ControllerNibProtocol {}


extension UIView {
  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    }
  }

}
