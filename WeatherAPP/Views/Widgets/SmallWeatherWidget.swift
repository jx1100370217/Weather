//
//  SmallWeatherWidget.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Small widget view (2x2) - Shows current temperature and condition
struct SmallWeatherWidget: View {
    let weather: WeatherData

    var body: some View {
        ZStack {
            // Background gradient based on condition
            widgetGradient
                .ignoresSafeArea()

            VStack(spacing: 8) {
                // Location name
                Text(weather.location.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)

                Spacer()

                // Weather icon
                Image(systemName: weather.currentWeather.condition.systemIconName)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)

                // Temperature
                Text("\(Int(weather.currentWeather.temperature))°")
                    .font(.system(size: 40, weight: .thin))
                    .foregroundColor(.white)

                // Condition
                Text(weather.currentWeather.condition.displayName)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)

                Spacer()

                // Last updated time
                Text(timeString)
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(12)
        }
        .frame(width: 155, height: 155)
        .cornerRadius(20)
        .shadow(radius: 5)
    }

    private var widgetGradient: LinearGradient {
        let condition = weather.currentWeather.condition
        let colors: [Color]

        switch condition {
        case .clear, .mostlyClear:
            colors = [Color(hex: "4A90E2"), Color(hex: "87CEEB")]
        case .rain, .drizzle, .heavyRain:
            colors = [Color(hex: "34495E"), Color(hex: "5D6D7E")]
        case .snow, .heavySnow:
            colors = [Color(hex: "D6EAF8"), Color(hex: "E8F8F5")]
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            colors = [Color(hex: "5D6D7E"), Color(hex: "85929E")]
        case .thunderstorm:
            colors = [Color(hex: "1C2833"), Color(hex: "283747")]
        default:
            colors = [Color(hex: "5DADE2"), Color(hex: "85C1E9")]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: weather.lastUpdated)
    }
}

// Preview removed due to compiler type-checking complexity
