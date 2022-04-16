//
//  ViewController.swift
//  Clima
//
//  Created by Paulo Antonelli on 19/03/22.

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager: WeatherManager = WeatherManager()
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        self.locationManager.delegate = self
        self.requestLocationAutorization()
        self.requestLocation()
        
        self.searchTextField.delegate = self
    }

    func fetchWeather() {
        if let city = searchTextField.text {
            self.weatherManager.fetchWeather(cityName: city)
        }
        view.endEditing(true)
    }
                                         
    @IBAction func searchPressed(_ sender: UITextField) {
        fetchWeather()
    }
    
    @IBAction func search(_ sender: UIButton) {
        fetchWeather()
    }
    
    @IBAction func updateMyLocation(_ sender: UIButton) {
        self.requestLocation()
    }
    
    func requestLocationAutorization() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingHeading()
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.fetchWeather()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            textField.placeholder = "Type Something to Search"
            return false
        }
        return true
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.weatherConditionSymbolName)
        }
    }
     
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.weatherManager.fetchWeather(lat: latitude, lng: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error)")
    }
}
