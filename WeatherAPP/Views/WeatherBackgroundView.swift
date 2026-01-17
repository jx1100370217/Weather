//
//  WeatherBackgroundView.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Dynamic background view that changes based on weather conditions
struct WeatherBackgroundView: View {
    let condition: WeatherCondition
    let isDaytime: Bool

    var body: some View {
        ZStack {
            // Base gradient
            baseGradient
                .ignoresSafeArea()

            // Weather-specific effects
            weatherEffects
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private var baseGradient: some View {
        switch condition {
        case .clear, .mostlyClear:
            if isDaytime {
                LinearGradient(
                    colors: [Color(hex: "4A90E2"), Color(hex: "87CEEB"), Color(hex: "E0F6FF")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            } else {
                LinearGradient(
                    colors: [Color(hex: "0B1026"), Color(hex: "1A2238"), Color(hex: "2C3E50")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }

        case .partlyCloudy, .mostlyCloudy:
            LinearGradient(
                colors: [Color(hex: "5D6D7E"), Color(hex: "85929E"), Color(hex: "AEB6BF")],
                startPoint: .top,
                endPoint: .bottom
            )

        case .cloudy:
            LinearGradient(
                colors: [Color(hex: "566573"), Color(hex: "717D7E"), Color(hex: "909497")],
                startPoint: .top,
                endPoint: .bottom
            )

        case .rain, .drizzle, .heavyRain:
            LinearGradient(
                colors: [Color(hex: "34495E"), Color(hex: "5D6D7E"), Color(hex: "7F8C8D")],
                startPoint: .top,
                endPoint: .bottom
            )

        case .thunderstorm:
            LinearGradient(
                colors: [Color(hex: "1C2833"), Color(hex: "283747"), Color(hex: "34495E")],
                startPoint: .top,
                endPoint: .bottom
            )

        case .snow, .heavySnow, .sleet:
            LinearGradient(
                colors: [Color(hex: "D6EAF8"), Color(hex: "E8F8F5"), Color(hex: "F4F6F7")],
                startPoint: .top,
                endPoint: .bottom
            )

        case .foggy:
            LinearGradient(
                colors: [Color(hex: "ABB2B9"), Color(hex: "CCD1D1"), Color(hex: "D5DBDB")],
                startPoint: .top,
                endPoint: .bottom
            )

        default:
            LinearGradient(
                colors: [Color(hex: "5DADE2"), Color(hex: "85C1E9"), Color(hex: "AED6F1")],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    @ViewBuilder
    private var weatherEffects: some View {
        switch condition {
        case .clear, .mostlyClear:
            // Premium floating particles for clear weather
            if isDaytime {
                FloatingParticlesEffect(particleCount: 25, color: .white.opacity(0.6))
            } else {
                FloatingParticlesEffect(particleCount: 30, color: .white.opacity(0.4))
            }

        case .rain, .heavyRain:
            RainEffect(intensity: condition == .heavyRain ? 1.0 : 0.6)

        case .snow, .heavySnow:
            SnowEffect(intensity: condition == .heavySnow ? 1.0 : 0.6)

        case .thunderstorm:
            ZStack {
                RainEffect(intensity: 0.8)
                CloudEffect()
            }

        case .cloudy, .mostlyCloudy:
            CloudEffect()

        case .partlyCloudy:
            ZStack {
                CloudEffect()
                FloatingParticlesEffect(particleCount: 15, color: .white.opacity(0.3))
            }

        default:
            EmptyView()
        }
    }
}

// MARK: - Weather Effects

struct RainEffect: View {
    let intensity: Double

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(50 * intensity), id: \.self) { _ in
                RainDrop(geometry: geometry)
            }
        }
    }
}

struct RainDrop: View {
    let geometry: GeometryProxy
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 0

    private let startX = CGFloat.random(in: 0...1)
    private let duration = Double.random(in: 0.5...1.0)
    private let delay = Double.random(in: 0...2)

    var body: some View {
        Rectangle()
            .fill(Color.white.opacity(0.3))
            .frame(width: 1.5, height: 20)
            .offset(x: startX * geometry.size.width, y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                        .delay(delay)
                ) {
                    offset = geometry.size.height + 20
                    opacity = 0.6
                }
            }
    }
}

struct SnowEffect: View {
    let intensity: Double

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(30 * intensity), id: \.self) { _ in
                Snowflake(geometry: geometry)
            }
        }
    }
}

struct Snowflake: View {
    let geometry: GeometryProxy
    @State private var offset: CGFloat = 0
    @State private var horizontalOffset: CGFloat = 0
    @State private var opacity: Double = 0

    private let startX = CGFloat.random(in: 0...1)
    private let size = CGFloat.random(in: 3...8)
    private let duration = Double.random(in: 2...4)
    private let delay = Double.random(in: 0...2)

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.8))
            .frame(width: size, height: size)
            .offset(x: startX * geometry.size.width + horizontalOffset, y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                        .delay(delay)
                ) {
                    offset = geometry.size.height + size
                    opacity = 0.8
                }

                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    horizontalOffset = 20
                }
            }
    }
}

struct CloudEffect: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<5, id: \.self) { index in
                Cloud(geometry: geometry, index: index)
            }
        }
    }
}

struct Cloud: View {
    let geometry: GeometryProxy
    let index: Int
    @State private var offset: CGFloat = 0

    private let yPosition: CGFloat
    private let duration: Double

    init(geometry: GeometryProxy, index: Int) {
        self.geometry = geometry
        self.index = index
        self.yPosition = CGFloat(index) * geometry.size.height / 6
        self.duration = Double.random(in: 20...40)
    }

    var body: some View {
        Capsule()
            .fill(Color.white.opacity(0.15))
            .frame(width: 200, height: 60)
            .blur(radius: 20)
            .offset(x: offset, y: yPosition)
            .onAppear {
                offset = -200
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                ) {
                    offset = geometry.size.width + 200
                }
            }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    WeatherBackgroundView(condition: .rain, isDaytime: false)
}
