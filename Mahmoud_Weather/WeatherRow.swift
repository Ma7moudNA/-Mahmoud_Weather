//
//  WeatherRow.swift
//  Mahmoud_Weather
//
//  Student: Mahmoud Al Nakawa (ID: 991745131)
//

import SwiftUI

struct WeatherRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title).foregroundColor(.secondary)
            Spacer()
            Text(value).bold()
        }
        .padding(.vertical, 6)
    }
}
