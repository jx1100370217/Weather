//
//  WeatherDetailsCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct WeatherDetailsCard: View {
    let current: CurrentWeather

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("详细信息")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    DetailItem(
                        icon: "humidity.fill",
                        title: "湿度",
                        value: "\(Int(current.humidity * 100))%"
                    )

                    DetailItem(
                        icon: "wind",
                        title: "风速",
                        value: String(format: "%.1f m/s", current.windSpeed)
                    )

                    DetailItem(
                        icon: "gauge.medium",
                        title: "气压",
                        value: String(format: "%.0f hPa", current.pressure)
                    )

                    DetailItem(
                        icon: "sun.max.fill",
                        title: "紫外线",
                        value: "\(current.uvIndex)"
                    )

                    DetailItem(
                        icon: "eye.fill",
                        title: "能见度",
                        value: String(format: "%.1f km", current.visibility / 1000)
                    )

                    DetailItem(
                        icon: "thermometer.medium",
                        title: "体感",
                        value: "\(Int(current.apparentTemperature))°"
                    )

                    DetailItem(
                        icon: "drop.fill",
                        title: "露点",
                        value: "\(Int(current.dewPoint))°"
                    )

                    DetailItem(
                        icon: "cloud.fill",
                        title: "云量",
                        value: "\(Int(current.cloudCover * 100))%"
                    )
                }
            }
        }
    }
}

struct DetailItem: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14))
            }
            .foregroundColor(.white.opacity(0.7))

            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.blue
        WeatherDetailsCard(
            current: CurrentWeather(
                temperature: 25,
                apparentTemperature: 27,
                condition: .clear,
                humidity: 0.65,
                pressure: 1013,
                windSpeed: 3.5,
                windDirection: 180,
                uvIndex: 5,
                visibility: 10000,
                cloudCover: 0.3,
                dewPoint: 18
            )
        )
        .padding()
    }
}
