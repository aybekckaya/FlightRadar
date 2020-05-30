//
//  UIView+Constraint.swift
//  InteractiveMenu
//
//  Created by aybek can kaya on 9.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//


import Foundation
import UIKit

struct ViewConstraint {
    var top:CGFloat?
    var leading:CGFloat?
    var trailing:CGFloat?
    var bottom:CGFloat?
    var height:CGFloat?
    var width:CGFloat?
    var centerX:CGFloat?
    var centerY:CGFloat?
}

class LayoutConstraint {
    var top:NSLayoutConstraint?
    var leading:NSLayoutConstraint?
    var trailing:NSLayoutConstraint?
    var bottom:NSLayoutConstraint?
    var height:NSLayoutConstraint?
    var width:NSLayoutConstraint?
    var centerX:NSLayoutConstraint?
    var centerY:NSLayoutConstraint?
}



extension UIView {
    @discardableResult
    func fitIntoSuperView(edges:UIEdgeInsets = UIEdgeInsets.zero , constraintBased:Bool = true)->LayoutConstraint {
        if constraintBased == true {
            return self.setEdgeConstraints(edges: edges)
        }
        return self.setFrameConstraints(edges: edges)
    }
    
    @discardableResult
    func activateViewConstraint(constraint:ViewConstraint , constraintBased:Bool)->LayoutConstraint {
        return self.setViewConstraint(constraint: constraint)
    }
}


// MARK: AutoLayout
extension UIView {
    
    fileprivate func setViewConstraint(constraint:ViewConstraint)->LayoutConstraint {
        assert(self.superview != nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        let layout = LayoutConstraint()
        if let top = constraint.top {
            layout.top = self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: top)
            layout.top!.isActive = true
        }
        
        if let leading = constraint.leading {
            layout.leading = self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: leading)
            layout.leading!.isActive = true
        }
        
        if let trailing = constraint.trailing {
            layout.trailing = self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: trailing)
            layout.trailing!.isActive = true
            
        }
        
        if let bottom = constraint.bottom {
            layout.bottom = self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: bottom)
            layout.bottom!.isActive = true
            
        }
        
        if let centerX = constraint.centerX {
            layout.centerX = self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: centerX)
            layout.centerX!.isActive = true
            
        }
        
        if let centerY = constraint.centerY {
            layout.centerY = self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: centerY)
            layout.centerY!.isActive = true
            
        }
        
        if let width = constraint.width {
            layout.width = self.widthAnchor.constraint(equalToConstant: width)
            layout.width!.isActive = true
            
        }
        
        if let height = constraint.height {
            layout.height = self.heightAnchor.constraint(equalToConstant: height)
            layout.height!.isActive = true
            
        }
        
        return layout
    }
    
    
    fileprivate func setEdgeConstraints(edges:UIEdgeInsets)->LayoutConstraint {
        return self.setViewConstraint(constraint: ViewConstraint(top: edges.top, leading: edges.left, trailing: edges.right, bottom: edges.bottom, height: nil, width: nil, centerX: nil, centerY: nil))
    }
}

// MARK: Frames
extension UIView {
    fileprivate func setFrameConstraints(edges:UIEdgeInsets)->LayoutConstraint {
        assert(self.superview != nil)
        self.translatesAutoresizingMaskIntoConstraints = true
        let xPos:CGFloat = edges.left
        let yPos:CGFloat = edges.top
        let width:CGFloat = self.superview!.frame.size.width - xPos - edges.right
        let height:CGFloat = self.superview!.frame.size.height - yPos - edges.bottom
        self.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        return LayoutConstraint()
    }
}

