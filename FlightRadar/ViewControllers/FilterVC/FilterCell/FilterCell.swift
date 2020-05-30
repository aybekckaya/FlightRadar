//
//  FilterCell.swift
//  FlightRadar
//
//  Created by aybek can kaya on 29.05.2020.
//  Copyright © 2020 aybek can kaya. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {
    static let identifier:String = "FilterCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imViewTick: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    private func setUpUI() {
        self.backgroundColor = UIColor.clear
        
    }
    
    func updateCell(countryName:String , isSelected:Bool) {
        self.lblTitle.text = countryName
        self.imViewTick.alpha =  isSelected == true ? 1.0 : 0.0
        self.layoutIfNeeded()
    }
}


