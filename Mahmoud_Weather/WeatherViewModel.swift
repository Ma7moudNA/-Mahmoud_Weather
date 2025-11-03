//
//  WeatherViewModel.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var city: String = "-"
    @Published var country: String = "-"
    @Published var tempC: String = "--"
    @Published var feelsLikeC: String = "--"
    @Published var wind: String = "--"
    @Published var humidity: String = "--"
    @Published var uv: String = "--"
    @Published var visibility: String = "--"
    @Published var conditionText: String = "-"
    @Published var conditionIconURL: URL?
    @Published var isLoading: Bool = false
    @Published var errorText: String?

    private let service: WeatherServiceType

    init(service: WeatherServiceType = WeatherService()) {
        self.service = service
    }

    func load(lat: Double, lon: Double) async {
        isLoading = true
        errorText = nil
        do {
            let res = try await service.fetch(lat: lat, lon: lon)
            city = res.location.name
            country = res.location.country
            tempC = String(format: "%.1f ℃", res.current.temp_c)
            feelsLikeC = String(format: "%.1f ℃", res.current.feelslike_c)
            wind = String(format: "%.1f kph (%@)", res.current.wind_kph, res.current.wind_dir)
            humidity = "\(res.current.humidity)%"
            uv = String(format: "%.1f", res.current.uv)
            visibility = String(format: "%.1f km", res.current.vis_km)
            conditionText = res.current.condition.text

            // icon is returned like "//cdn.weatherapi.com/...", normalize to https
            var icon = res.current.condition.icon
            if icon.hasPrefix("//") { icon = "https:\(icon)" }
            conditionIconURL = URL(string: icon)
        } catch {
            errorText = "Failed to load weather."
        }
        isLoading = false
    }
}
