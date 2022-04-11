//
//  WeatherCell.swift
//  WeatherInformation
//
//  Created by Satyadip Singha on 08/04/22.
//  Copyright © 2022 Satyadip Singha. All rights reserved.
//

import Foundation
import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak private var cityNameLabel: UILabel!
    @IBOutlet weak private var temperatureLabel: UILabel!
    
    //MARK:- Updating weather cell 
    
    func configure(_ vm: WeatherViewModel) {
        self.cityNameLabel.text = vm.city
        self.temperatureLabel.text = vm.temperature.formatTemperature()
    }
}
