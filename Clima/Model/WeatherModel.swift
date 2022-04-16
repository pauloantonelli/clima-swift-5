//
//  WeatherModel.swift
//  Clima
//
//  Created by Paulo Antonelli on 19/03/22.

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        let result = String(format:  "%.1f",temperature)
        return result
    }
    var weatherConditionSymbolName: String {
        let result = self.getWeatherConditionSymbolName(weatherId: self.conditionId)
        return result
    }
    
    private func getWeatherConditionSymbolName(weatherId value: Int) -> String {
        switch value {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "sun.min"
        }
    }
}
