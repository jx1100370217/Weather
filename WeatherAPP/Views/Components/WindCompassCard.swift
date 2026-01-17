//
//  WindCompassCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Wind compass visualization card showing wind speed and direction
struct WindCompassCard: View {
    let windSpeed: Double
    let windDirection: Double
    @State private var arrowRotation: Double = 0

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "wind")
                        .font(.system(size: 20))
                        .foregroundColor(.white)

                    Text("风力风向")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }

                HStack(spacing: 24) {
                    // Wind compass
                    ZStack {
                        // Compass background
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 2)
                            .frame(width: 140, height: 140)

                        // Cardinal directions
                        ForEach(["N", "E", "S", "W"], id: \.self) { direction in
                            Text(direction)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                                .offset(y: compassOffset(for: direction))
                                .rotationEffect(.degrees(compassRotation(for: direction)))
                        }

                        // Center circle
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.cyan.opacity(0.6),
                                        Color.blue.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 25
                                )
                            )
                            .frame(width: 50, height: 50)

                        // Wind direction arrow
                        Image(systemName: "location.north.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .shadow(color: .cyan, radius: 8)
                            .rotationEffect(.degrees(arrowRotation))
                    }
                    .frame(width: 140, height: 140)

                    // Wind details
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("风速")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))

                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(String(format: "%.1f", windSpeed))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)

                                Text("m/s")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }

                        Divider()
                            .background(Color.white.opacity(0.3))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("风向")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))

                            Text(windDirectionName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("级别")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))

                            Text(windScale)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(windScaleColor)
                        }
                    }

                    Spacer()
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
                arrowRotation = windDirection
            }
        }
    }

    private func compassOffset(for direction: String) -> CGFloat {
        switch direction {
        case "N": return -70
        case "S": return 70
        case "E": return 0
        case "W": return 0
        default: return 0
        }
    }

    private func compassRotation(for direction: String) -> Double {
        switch direction {
        case "E": return 90
        case "W": return -90
        default: return 0
        }
    }

    private var windDirectionName: String {
        let directions = ["北", "东北", "东", "东南", "南", "西南", "西", "西北"]
        let index = Int((windDirection + 22.5) / 45.0) % 8
        return directions[index] + "风"
    }

    private var windScale: String {
        // Beaufort scale approximation
        switch windSpeed {
        case 0..<0.3: return "0级 无风"
        case 0.3..<1.6: return "1级 软风"
        case 1.6..<3.4: return "2级 轻风"
        case 3.4..<5.5: return "3级 微风"
        case 5.5..<8.0: return "4级 和风"
        case 8.0..<10.8: return "5级 清风"
        case 10.8..<13.9: return "6级 强风"
        case 13.9..<17.2: return "7级 疾风"
        case 17.2..<20.8: return "8级 大风"
        case 20.8..<24.5: return "9级 烈风"
        default: return "10+级 狂风"
        }
    }

    private var windScaleColor: Color {
        switch windSpeed {
        case 0..<5.5: return .green
        case 5.5..<10.8: return .yellow
        case 10.8..<17.2: return .orange
        default: return .red
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

        WindCompassCard(windSpeed: 5.2, windDirection: 135)
            .padding()
    }
}
