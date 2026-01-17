//
//  MinutelyPrecipitationCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct MinutelyPrecipitationCard: View {
    let data: [MinutelyPrecipitation]

    private var precipitationMessage: String {
        let hasSignificantRain = data.prefix(10).contains { $0.precipitationIntensity > 0.1 }

        if hasSignificantRain {
            if let endIndex = data.firstIndex(where: { $0.precipitationIntensity < 0.1 }) {
                let minutes = endIndex
                return "降雨将在 \(minutes) 分钟后停止"
            } else {
                return "未来一小时持续降雨"
            }
        } else {
            if let startIndex = data.firstIndex(where: { $0.precipitationIntensity > 0.1 }) {
                return "\(startIndex) 分钟后开始降雨"
            } else {
                return "未来一小时无降雨"
            }
        }
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "cloud.rain.fill")
                        .font(.system(size: 20))
                    Text("分钟级降水")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)

                Text(precipitationMessage)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)

                // Precipitation chart
                PrecipitationChart(data: data)
                    .frame(height: 60)
            }
        }
    }
}

struct PrecipitationChart: View {
    let data: [MinutelyPrecipitation]

    var body: some View {
        GeometryReader { geometry in
            let maxIntensity = data.map { $0.precipitationIntensity }.max() ?? 1.0
            let barWidth = geometry.size.width / CGFloat(data.count)

            HStack(spacing: 0) {
                ForEach(data.indices, id: \.self) { index in
                    let intensity = data[index].precipitationIntensity
                    let normalizedHeight = maxIntensity > 0 ? intensity / maxIntensity : 0

                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(intensityColor(for: intensity))
                            .frame(width: barWidth - 1, height: geometry.size.height * normalizedHeight)
                    }
                }
            }
        }
    }

    private func intensityColor(for intensity: Double) -> Color {
        if intensity < 0.1 {
            return Color.white.opacity(0.3)
        } else if intensity < 0.5 {
            return Color.blue.opacity(0.6)
        } else {
            return Color.blue.opacity(0.9)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        MinutelyPrecipitationCard(data: [])
            .padding()
    }
}
