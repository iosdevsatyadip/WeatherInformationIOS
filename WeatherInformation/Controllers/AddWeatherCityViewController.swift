//
//  AddWeatherCityViewController.swift
//  WeatherInformation
//
//  Created by Satyadip Singha on 08/04/22.
//  Copyright © 2022 Satyadip Singha. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

protocol AddWeatherDelegate {
    func addWeatherDidSave(vm: WeatherViewModel)
}

class AddWeatherCityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak private var cityNameTextField: UITextField!
    private var weatherService = WeatherService()
    var delegate: AddWeatherDelegate?
    var reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Testfield validation and API caling
    
    @IBAction func saveCityButtonPressed() {
        if cityNameTextField.text?.count ?? 0 > 0 {
            self.weatherApiCall()
        } else {
            self.showAlertMessage(title: "Error!!!", message: "Please enter city name")
        }
        
    }
    
    //MARK:-  Fetch responspe received from API
    
    private func fetchData(city: String, completion: @escaping (Result<WeatherResponse, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await weatherService.getWeatherDetails(city: city, units: Constants.unit(), appID: Constants.appID)
            completion(result)
        }
    }
    
    //MARK:-  API calling
    
    func weatherApiCall() {
        if reachabilityManager?.isReachable == true {
            if let city = cityNameTextField.text {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                fetchData(city: city) { [weak self] result in
                    guard let self = self else { return }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    switch result {
                    case .success(let response):
                        let vm = WeatherViewModel(weather: response)
                        self.delegate?.addWeatherDidSave(vm: vm)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        self.showAlertMessage(title: "", message: error.customMessage)
                    }
                }
            }
        } else {
            self.showAlertMessage(title: "Error!!!", message: "Internet connection is not available")
        }
    }
    
    //MARK:- Displaying alert
    
    func showAlertMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Mark:- Close button Action 
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTextField.resignFirstResponder()
        return true
    }

}




