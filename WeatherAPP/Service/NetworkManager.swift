//
//  NetworkManager.swift
//  WeatherAPP
//
//  Created by Buğra Özuğurlu on 6.06.2023.
//

import Foundation
import CoreLocation

struct NetworkManager {
    
     let weatherUrl = "\(NetworkHelper.baseUrl)appid=\(NetworkHelper.apiKey)&units=metric"
    
    private func fetchWeather(url: URL, completion: @escaping (Result<Weather, ErrorType>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(Weather.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(.decodingError))
            }
        }.resume()
    }
     public func fetchWeatherCityName(cityName: String, completion: @escaping (Result<Weather, ErrorType>) -> Void) {
         guard let url = URL(string: "\(weatherUrl)&q=\(cityName)") else {return}
         fetchWeather(url: url, completion: completion)
        
    }
    public func fetchWeatherLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<Weather, ErrorType>) -> Void) {
        guard let url = URL(string: "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)") else {return}
        fetchWeather(url: url, completion: completion)
    }
}
