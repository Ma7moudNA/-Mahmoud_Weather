//
//  WeatherService.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import Foundation

protocol WeatherServiceType {
    func fetch(lat: Double, lon: Double) async throws -> WeatherResponse
}

final class WeatherService: WeatherServiceType {
    // keep private in real projects; for assignment it is fine in code
    private let apiKey = "c88cb27838dd4b458e8190037250211"

    func fetch(lat: Double, lon: Double) async throws -> WeatherResponse {
        let query = String(format: "%.6f,%.6f", lat, lon)
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
