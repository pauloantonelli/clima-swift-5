//
//  File.swift
//  Clima
//
//  Created by Paulo Antonelli on 19/03/22.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    let appId: String  = "96b7b09f0fd6fc13a12f6e144ce68f4d"
    let weatherUrl: String = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchWeather(cityName value: String) {
        let replacedCityName: String = value.replacingOccurrences(of: " ", with: "%20", options: .literal)
        let url: String = "\(self.weatherUrl)?q=\(replacedCityName)&appid=\(appId)&units=metric&lang=pt_br"
        let replacedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.networkRequest(with: url)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let url: String = "\(self.weatherUrl)?lat=\(lat)&lon=\(lng)&appid=\(appId)&units=metric&lang=pt_br"
        self.networkRequest(with: url)
    }
    
    func networkRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSessionr
            let session = URLSession(configuration: .default)
            // 3. give the session a task
            let task = session.dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?,  error: Error?) -> Void in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
                /*if let safeResponse = response {
                    print(safeResponse) // visualização do corpo da requisicao
                }*/
            })
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId: Int = result.weather[0].id
            let cityName: String = result.name
            let temperature: Double = result.main.temp
            let weatherModel: WeatherModel = WeatherModel(conditionId: conditionId, cityName: cityName, temperature: temperature)
            return weatherModel
        } catch let error {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
