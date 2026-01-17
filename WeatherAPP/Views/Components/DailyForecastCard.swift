//
//  DailyForecastCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct DailyForecastCard: View {
    let daily: [DailyWeather]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                    Text("15天预报")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)

                VStack(spacing: 12) {
                    ForEach(daily.prefix(15)) { day in
                        DailyItem(day: day, allDays: Array(daily.prefix(15)))
                        if day.id != daily.prefix(15).last?.id {
                            Divider()
                                .background(Color.white.opacity(0.2))
                        }
                    }
                }
            }
        }
    }
}

struct DailyItem: View {
    let day: DailyWeather
    let allDays: [DailyWeather]

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "zh_CN")

        let calendar = Calendar.current
        if calendar.isDateInToday(day.date) {
            return "今天"
        } else if calendar.isDateInTomorrow(day.date) {
            return "明天"
        } else {
            return formatter.string(from: day.date)
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            Text(dateString)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)

            Image(systemName: day.condition.systemIconName)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)

            Text("\(Int(day.precipitationChance * 100))%")
                .font(.system(size: 14))
                .foregroundColor(.cyan)
                .frame(width: 40)

            Spacer()

            // Temperature range bar
            TemperatureRangeBar(
                low: day.lowTemperature,
                high: day.highTemperature,
                allLows: allDays.map { $0.lowTemperature },
                allHighs: allDays.map { $0.highTemperature }
            )
            .frame(width: 120)

            HStack(spacing: 4) {
                Text("\(Int(day.lowTemperature))°")
                    .foregroundColor(.white.opacity(0.7))
                Text("\(Int(day.highTemperature))°")
                    .foregroundColor(.white)
            }
            .font(.system(size: 16, weight: .medium))
            .frame(width: 80, alignment: .trailing)
        }
    }
}

struct TemperatureRangeBar: View {
    let low: Double
    let high: Double
    let allLows: [Double]
    let allHighs: [Double]

    private var normalizedLow: Double {
        let minTemp = allLows.min() ?? low
        let maxTemp = allHighs.max() ?? high
        let range = maxTemp - minTemp
        return range > 0 ? (low - minTemp) / range : 0.5
    }

    private var normalizedHigh: Double {
        let minTemp = allLows.min() ?? low
        let maxTemp = allHighs.max() ?? high
        let range = maxTemp - minTemp
        return range > 0 ? (high - minTemp) / range : 0.5
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 4)

                // Temperature range
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * (normalizedHigh - normalizedLow),
                        height: 4
                    )
                    .offset(x: geometry.size.width * normalizedLow)
            }
        }
        .frame(height: 4)
    }
}

#Preview {
    ZStack {
        Color.blue
        DailyForecastCard(daily: [])
            .padding()
    }
}
