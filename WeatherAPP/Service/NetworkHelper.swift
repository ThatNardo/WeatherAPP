//
//  NetworkHelper.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 6.06.2023.
//

import Foundation

enum ErrorType: String,Error {
    case invalidData = "Invalid Data"
    case invalidUrl = "Invalid Url"
    case decodingError = "Decoding Error"

}
struct NetworkHelper {
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    static let apiKey = "d6a61d20e7e4baa20d14b727cc269748"
}
