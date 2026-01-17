//
//  MediumWeatherWidget.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Medium widget view (2x4) - Shows current weather + hourly forecast
struct MediumWeatherWidget: View {
    let weather: WeatherData

    var body: some View {
        ZStack {
            // Background gradient
            widgetGradient
                .ignoresSafeArea()

            HStack(spacing: 16) {
                // Left side: Current weather
                VStack(alignment: .leading, spacing: 4) {
                    Text(weather.location.name)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: weather.currentWeather.condition.systemIconName)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .symbolRenderingMode(.hierarchical)

                    Text("\(Int(weather.currentWeather.temperature))°")
                        .font(.system(size: 48, weight: .thin))
                        .foregroundColor(.white)

                    Text(weather.currentWeather.condition.displayName)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()

                    HStack(spacing: 12) {
                        Label("\(Int(weather.currentWeather.humidity * 100))%", systemImage: "humidity.fill")
                        Label("\(Int(weather.currentWeather.windSpeed))m/s", systemImage: "wind")
                    }
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .background(Color.white.opacity(0.3))

                // Right side: Hourly forecast
                VStack(alignment: .leading, spacing: 8) {
                    Text("未来6小时")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)

                    ForEach(weather.hourlyForecast.prefix(6)) { hour in
                        HourlyWidgetItem(hour: hour)
                    }
                }
            }
            .padding(16)
        }
        .frame(width: 329, height: 155)
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
}

struct HourlyWidgetItem: View {
    let hour: HourlyWeather

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: hour.date)
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(timeString)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 40, alignment: .leading)

            Image(systemName: hour.condition.systemIconName)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 20)

            Text("\(Int(hour.precipitationChance * 100))%")
                .font(.system(size: 10))
                .foregroundColor(.cyan)
                .frame(width: 30, alignment: .trailing)

            Text("\(Int(hour.temperature))°")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 30, alignment: .trailing)
        }
    }
}

// Preview removed due to compiler type-checking complexity
