//
//  HomeViewModel.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 6.06.2023.
//

import Foundation

final class HomeViewModel {
    let id: Int
    let cityName: String
    let temperature: Double
    
    init(weatherModel: Weather) {
        self.id = weatherModel.weather[0].id
        self.cityName = weatherModel.name
        self.temperature = weatherModel.main.temp
    }
    var temperatureString: String? {
        return String(format: "%.1f", temperature)
    }
    var statusImageName: String {
        switch id {
        case 200...232:
            return "cloud.bolt"
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
        case 801...884:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
