//
//  HourlyForecastCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct HourlyForecastCard: View {
    let hourly: [HourlyWeather]

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 20))
                    Text("24小时预报")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(hourly.prefix(24)) { hour in
                            HourlyItem(hour: hour)
                        }
                    }
                }
            }
        }
    }
}

struct HourlyItem: View {
    let hour: HourlyWeather

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: hour.date)
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(timeString)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))

            Image(systemName: hour.condition.systemIconName)
                .font(.system(size: 24))
                .foregroundColor(.white)

            Text("\(Int(hour.precipitationChance * 100))%")
                .font(.system(size: 12))
                .foregroundColor(.cyan)

            Text("\(Int(hour.temperature))°")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: 60)
    }
}

#Preview {
    ZStack {
        Color.blue
        HourlyForecastCard(hourly: [])
            .padding()
    }
}
