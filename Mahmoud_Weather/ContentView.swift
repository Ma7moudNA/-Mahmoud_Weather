//
//  ContentView.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var location: LocationManager
    @EnvironmentObject private var vm: WeatherViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                VStack(spacing: 16) {

                    // MARK: - Location Permission and Error Messages
                    if location.authorizationStatus == .denied || location.authorizationStatus == .restricted {
                        VStack(spacing: 8) {
                            Text("Location access is denied. Enable it in Settings.")
                                .foregroundColor(.red)

                            Button("Open Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    openURL(url)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if let err = location.lastError, location.latitude == nil {
                        // Temporary error before we get a valid location
                        Text(err).foregroundColor(.red)
                        Button("Enable Location") { location.requestPermission() }
                            .buttonStyle(.borderedProminent)
                    }

                    // MARK: - City, Country, and Weather Condition
                    HStack(spacing: 12) {
                        if let url = vm.conditionIconURL {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let img):
                                    img.resizable()
                                        .frame(width: 48, height: 48)
                                case .failure:
                                    Image(systemName: "cloud.sun")
                                        .font(.title)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "cloud.sun").font(.title)
                        }

                        VStack(alignment: .leading) {
                            Text("\(vm.city), \(vm.country)")
                                .font(.title2).bold()
                            Text(vm.conditionText)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)

                    // MARK: - Temperature Display
                    VStack(spacing: 8) {
                        Text(vm.tempC)
                            .font(.system(size: 48, weight: .semibold))
                        Text("Feels like \(vm.feelsLikeC)")
                            .foregroundColor(.secondary)
                    }

                    // MARK: - Weather Details
                    VStack(spacing: 0) {
                        WeatherRow(title: "Wind", value: vm.wind)
                        Divider()
                        WeatherRow(title: "Humidity", value: vm.humidity)
                        Divider()
                        WeatherRow(title: "UV Index", value: vm.uv)
                        Divider()
                        WeatherRow(title: "Visibility", value: vm.visibility)
                    }
                    .padding(.horizontal)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    // MARK: - Loading or Error Messages
                    if vm.isLoading {
                        ProgressView().padding(.top, 8)
                    } else if let err = vm.errorText {
                        Text(err).foregroundColor(.red)
                    }

                    Spacer()
                }
                .padding(.top, 12)
            }
            .navigationTitle("Mahmoud_Weather")
            // Fetch weather every time coordinates change
            .task(id: location.latitude ?? 0) {
                if let lat = location.latitude, let lon = location.longitude {
                    await vm.load(lat: lat, lon: lon)
                }
            }
        }
    }
}
