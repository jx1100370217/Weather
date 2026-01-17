//
//  SunMoonCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct SunMoonCard: View {
    let daily: DailyWeather

    private var sunriseTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: daily.sunrise)
    }

    private var sunsetTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: daily.sunset)
    }

    private var moonPhaseDescription: String {
        let phase = daily.moonPhase
        switch phase {
        case 0.0..<0.125: return "新月"
        case 0.125..<0.25: return "上弦月"
        case 0.25..<0.375: return "盈凸月"
        case 0.375..<0.5: return "满月"
        case 0.5..<0.625: return "亏凸月"
        case 0.625..<0.75: return "下弦月"
        case 0.75..<0.875: return "残月"
        default: return "新月"
        }
    }

    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                // Sun section
                VStack(alignment: .leading, spacing: 12) {
                    Text("日出日落")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Image(systemName: "sunrise.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)

                            Text("日出")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))

                            Text(sunriseTime)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        VStack(spacing: 8) {
                            Image(systemName: "sunset.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)

                            Text("日落")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))

                            Text(sunsetTime)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        VStack(spacing: 8) {
                            Image(systemName: "sun.max.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.yellow)

                            Text("UV指数")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))

                            Text("\(daily.uvIndex)")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Moon section
                VStack(alignment: .leading, spacing: 12) {
                    Text("月相")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    HStack {
                        Image(systemName: moonPhaseIcon)
                            .font(.system(size: 40))
                            .foregroundColor(.yellow.opacity(0.8))

                        Spacer()

                        Text(moonPhaseDescription)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var moonPhaseIcon: String {
        let phase = daily.moonPhase
        switch phase {
        case 0.0..<0.125: return "moon.fill"
        case 0.125..<0.25: return "moonphase.first.quarter"
        case 0.25..<0.375: return "moonphase.waxing.gibbous"
        case 0.375..<0.5: return "moon.circle.fill"
        case 0.5..<0.625: return "moonphase.waning.gibbous"
        case 0.625..<0.75: return "moonphase.last.quarter"
        case 0.75..<0.875: return "moonphase.waning.crescent"
        default: return "moon.fill"
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        SunMoonCard(
            daily: DailyWeather(
                date: Date(),
                highTemperature: 25,
                lowTemperature: 15,
                condition: .clear,
                precipitationChance: 0.1,
                sunrise: Date(),
                sunset: Date().addingTimeInterval(43200),
                moonPhase: 0.25,
                uvIndex: 5
            )
        )
        .padding()
    }
}
