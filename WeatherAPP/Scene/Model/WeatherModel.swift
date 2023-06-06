//
//  WeatherModel.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 5.06.2023.
//

import Foundation


// MARK: - Weather
struct Weather: Codable {
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let name: String
}
// MARK: - Main
struct Main: Codable {
    let temp: Double
}
// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
}
