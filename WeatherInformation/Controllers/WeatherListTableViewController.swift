//
//  WeatherListTableViewController.swift
//  WeatherInformation
//
//  Created by Satyadip Singha on 08/04/22.
//  Copyright © 2022 Satyadip Singha. All rights reserved.
//

import Foundation
import UIKit

class WeatherListTableViewController: UITableViewController, AddWeatherDelegate {
    
    private var weatherListViewModel = WeatherListViewModel()
    private var lastUnitSelection: Unit!
    let cellReuseIdentifier = "WeatherCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.value(forKey: "unit") as? String {
            self.lastUnitSelection = Unit(rawValue: value)!
        }
    }
    
    //MARK:-  Update viewmodel and reload 
    
    func addWeatherDidSave(vm: WeatherViewModel) {
        weatherListViewModel.addWeatherViewModel(vm)
        self.tableView.reloadData()
    }
        
    //MARK:-  Navigations
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddWeatherCityViewController" {
            prepareSegueForAddWeatherCityViewController(segue: segue)
        } else if segue.identifier == "SettingsTableViewController" {
            prepareSegueForSettingsTableViewController(segue: segue)
        }
    }
    
    private func prepareSegueForSettingsTableViewController(segue: UIStoryboardSegue) {
        let nav = segue.destination as? UINavigationController
        let settingsTVC = nav?.viewControllers.first as? SettingsTableViewController
        settingsTVC?.delegate = self
    }
    
    
    func prepareSegueForAddWeatherCityViewController(segue: UIStoryboardSegue) {
        let nav = segue.destination as? UINavigationController
        let addWeatherCityVC = nav?.viewControllers.first as? AddWeatherCityViewController
        addWeatherCityVC?.delegate = self
    }
    
    //MARK:- Tableview DataSources
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! WeatherCell? else { fatalError() }
        let weatherVM = weatherListViewModel.modelAt(indexPath.row)
        cell.configure(weatherVM)
        return cell
    }
    
}

extension WeatherListTableViewController: SettingsDelegate {
    
    //MARK:- Updating unit and respective value and update UI
    
    func settingsDone(vm: SettingsViewModel) {
        if lastUnitSelection.rawValue != vm.selectedUnit.rawValue {
            weatherListViewModel.updateUnit(to: vm.selectedUnit)
            lastUnitSelection = Unit(rawValue: vm.selectedUnit.rawValue) ?? Unit.fahrenheit
            tableView.reloadData()
        }
    }
}
