//
//  AirQualityCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct AirQualityCard: View {
    let airQuality: AirQuality

    private var aqi: Int { airQuality.aqi }
    private var category: AQICategory { airQuality.aqiCategory }
    private var pollutants: [String: Double] { airQuality.pollutants }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "aqi.medium")
                        .font(.system(size: 20))
                        .foregroundColor(.white)

                    Text("空气质量")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }

                // AQI Value and Category
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(aqi)")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(category.color)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(category.color)

                            Text(category.description)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }

                    // AQI Scale Bar
                    AQIScaleBar(aqi: aqi)
                        .frame(height: 8)
                        .cornerRadius(4)
                }

                Divider()
                    .background(Color.white.opacity(0.3))

                // Main Pollutants
                VStack(spacing: 12) {
                    ForEach(pollutants.sorted(by: { $0.value > $1.value }).prefix(3), id: \.key) { pollutant, value in
                        PollutantRow(name: pollutant, value: value)
                    }
                }
            }
            .padding()
        }
    }
}

struct PollutantRow: View {
    let name: String
    let value: Double

    var body: some View {
        HStack {
            Text(pollutantDisplayName(name))
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))

            Spacer()

            Text(String(format: "%.1f μg/m³", value))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }

    private func pollutantDisplayName(_ key: String) -> String {
        switch key {
        case "pm25": return "PM2.5"
        case "pm10": return "PM10"
        case "o3": return "臭氧"
        case "no2": return "二氧化氮"
        case "so2": return "二氧化硫"
        case "co": return "一氧化碳"
        default: return key.uppercased()
        }
    }
}

struct AQIScaleBar: View {
    let aqi: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.green,
                        Color.yellow,
                        Color.orange,
                        Color.red,
                        Color.purple,
                        Color(red: 0.5, green: 0, blue: 0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(4)

                // Current position indicator
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(radius: 2)
                    .offset(x: calculatePosition(for: aqi, in: geometry.size.width) - 8)
            }
        }
    }

    private func calculatePosition(for aqi: Int, in width: CGFloat) -> CGFloat {
        let maxAQI: CGFloat = 500
        let position = CGFloat(min(aqi, Int(maxAQI))) / maxAQI * width
        return min(max(position, 0), width)
    }
}

extension AQICategory {
    var description: String {
        switch self {
        case .good: return "空气质量令人满意"
        case .moderate: return "空气质量可接受"
        case .unhealthyForSensitive: return "敏感人群注意"
        case .unhealthy: return "对所有人不健康"
        case .veryUnhealthy: return "对所有人很不健康"
        case .hazardous: return "健康警告"
        }
    }

    var color: Color {
        switch self {
        case .good: return .green
        case .moderate: return .yellow
        case .unhealthyForSensitive: return .orange
        case .unhealthy: return .red
        case .veryUnhealthy: return .purple
        case .hazardous: return Color(red: 0.5, green: 0, blue: 0)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue, Color.purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        AirQualityCard(
            airQuality: AirQuality(
                aqi: 85,
                category: "moderate",
                pollutants: [
                    "pm25": 35.2,
                    "pm10": 58.1,
                    "o3": 42.3,
                    "no2": 28.5
                ],
                dominantPollutant: "pm25"
            )
        )
        .padding()
    }
}
