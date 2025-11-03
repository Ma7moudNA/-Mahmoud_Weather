//
//  WeatherModels.swift
//  Mahmoud_Weather
//
//  Mahmoud Al Nakawa (ID: 991745131)
//

import Foundation

struct WeatherResponse: Decodable {
    let location: Location
    let current: Current
}

struct Location: Decodable {
    let name: String     // city
    let country: String
}

struct Current: Decodable {
    let temp_c: Double
    let feelslike_c: Double
    let wind_kph: Double
    let wind_dir: String
    let humidity: Int
    let uv: Double
    let vis_km: Double
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String     // icon path like "//cdn.weatherapi.com/..."
}
