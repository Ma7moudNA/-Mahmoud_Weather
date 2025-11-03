//
//  Mahmoud_WeatherApp.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import SwiftUI

@main
struct Mahmoud_WeatherApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(viewModel)
        }
    }
}
