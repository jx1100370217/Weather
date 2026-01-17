//
//  LargeWeatherWidget.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Large widget view (4x4) - Shows comprehensive weather information
struct LargeWeatherWidget: View {
    let weather: WeatherData

    var body: some View {
        ZStack {
            // Background gradient
            widgetGradient
                .ignoresSafeArea()

            VStack(spacing: 12) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(weather.location.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text(weather.currentWeather.condition.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(Int(weather.currentWeather.temperature))°")
                            .font(.system(size: 48, weight: .thin))
                            .foregroundColor(.white)

                        if let daily = weather.dailyForecast.first {
                            Text("↑\(Int(daily.highTemperature))° ↓\(Int(daily.lowTemperature))°")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.3))

                // Hourly forecast
                VStack(alignment: .leading, spacing: 6) {
                    Text("未来8小时")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(weather.hourlyForecast.prefix(8)) { hour in
                                VStack(spacing: 4) {
                                    Text(hourTimeString(hour.date))
                                        .font(.system(size: 10))
                                        .foregroundColor(.white.opacity(0.7))

                                    Image(systemName: hour.condition.systemIconName)
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)

                                    Text("\(Int(hour.temperature))°")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 35)
                            }
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.3))

                // Weather details
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        DetailCell(icon: "humidity.fill", value: "\(Int(weather.currentWeather.humidity * 100))%", label: "湿度")
                        DetailCell(icon: "wind", value: "\(Int(weather.currentWeather.windSpeed))m/s", label: "风速")
                        DetailCell(icon: "gauge.medium", value: "\(Int(weather.currentWeather.pressure))hPa", label: "气压")
                    }

                    HStack(spacing: 16) {
                        DetailCell(icon: "sun.max.fill", value: "\(weather.currentWeather.uvIndex)", label: "紫外线")
                        DetailCell(icon: "eye.fill", value: "\(Int(weather.currentWeather.visibility/1000))km", label: "能见度")
                        DetailCell(icon: "thermometer.medium", value: "\(Int(weather.currentWeather.apparentTemperature))°", label: "体感")
                    }
                }

                Spacer()

                // Footer
                Text("更新于 \(timeString)")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(16)
        }
        .frame(width: 329, height: 329)
        .cornerRadius(20)
        .shadow(radius: 5)
    }

    private var widgetGradient: LinearGradient {
        let condition = weather.currentWeather.condition
        let colors: [Color]

        switch condition {
        case .clear, .mostlyClear:
            colors = [Color(hex: "4A90E2"), Color(hex: "87CEEB"), Color(hex: "A8D8EA")]
        case .rain, .drizzle, .heavyRain:
            colors = [Color(hex: "34495E"), Color(hex: "5D6D7E"), Color(hex: "7F8C8D")]
        case .snow, .heavySnow:
            colors = [Color(hex: "D6EAF8"), Color(hex: "E8F8F5"), Color(hex: "F4F6F7")]
        case .cloudy, .mostlyCloudy, .partlyCloudy:
            colors = [Color(hex: "5D6D7E"), Color(hex: "85929E"), Color(hex: "AEB6BF")]
        case .thunderstorm:
            colors = [Color(hex: "1C2833"), Color(hex: "283747"), Color(hex: "34495E")]
        default:
            colors = [Color(hex: "5DADE2"), Color(hex: "85C1E9"), Color(hex: "AED6F1")]
        }

        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func hourTimeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: weather.lastUpdated)
    }
}

struct DetailCell: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)

            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}


// Preview removed due to compiler type-checking complexity
