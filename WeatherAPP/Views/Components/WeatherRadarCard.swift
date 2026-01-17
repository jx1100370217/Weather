//
//  WeatherRadarCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI
import MapKit

struct WeatherRadarCard: View {
    let location: Location
    @State private var region: MKCoordinateRegion
    @State private var animationProgress: Double = 0
    @State private var isAnimating = false

    init(location: Location) {
        self.location = location
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        ))
    }

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack {
                    Image(systemName: "cloud.rainbow.half.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)

                    Text("天气雷达")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    // Animation toggle
                    Button(action: {
                        isAnimating.toggle()
                        if isAnimating {
                            startAnimation()
                        }
                    }) {
                        Image(systemName: isAnimating ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }

                // Radar Map View
                ZStack {
                    // Base map
                    Map(coordinateRegion: $region, interactionModes: [])
                        .frame(height: 300)
                        .cornerRadius(12)
                        .disabled(true)

                    // Radar overlay (simulated)
                    RadarOverlay(animationProgress: animationProgress)
                        .frame(height: 300)
                        .cornerRadius(12)
                        .allowsHitTesting(false)

                    // Center marker
                    Image(systemName: "location.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.3), radius: 2)
                }

                // Legend
                HStack(spacing: 16) {
                    LegendItem(color: .green, label: "小雨")
                    LegendItem(color: .yellow, label: "中雨")
                    LegendItem(color: .orange, label: "大雨")
                    LegendItem(color: .red, label: "暴雨")
                }
                .padding(.top, 8)

                // Time indicator
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))

                    Text("实时雷达数据")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))

                    Spacer()

                    Text(formattedTime)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !isAnimating {
                timer.invalidate()
                return
            }
            animationProgress += 0.02
            if animationProgress > 1.0 {
                animationProgress = 0
            }
        }
    }
}

struct RadarOverlay: View {
    let animationProgress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Simulated radar precipitation patterns
                ForEach(0..<15, id: \.self) { index in
                    RadarBlob(
                        index: index,
                        progress: animationProgress,
                        size: geometry.size
                    )
                }

                // Scanning effect
                ScanningBeam(progress: animationProgress)
                    .opacity(0.3)
            }
        }
    }
}

struct RadarBlob: View {
    let index: Int
    let progress: Double
    let size: CGSize

    private var position: CGPoint {
        let angle = Double(index) * (360.0 / 15.0) * .pi / 180.0
        let radius = size.width * 0.3 * (0.5 + 0.5 * sin(progress * 2 * .pi + Double(index)))
        return CGPoint(
            x: size.width / 2 + cos(angle) * radius,
            y: size.height / 2 + sin(angle) * radius
        )
    }

    private var color: Color {
        let intensity = 0.5 + 0.5 * sin(progress * 2 * .pi + Double(index))
        if intensity < 0.3 {
            return .green
        } else if intensity < 0.6 {
            return .yellow
        } else if intensity < 0.8 {
            return .orange
        } else {
            return .red
        }
    }

    var body: some View {
        Circle()
            .fill(color.opacity(0.4))
            .frame(width: 40, height: 40)
            .blur(radius: 8)
            .position(position)
    }
}

struct ScanningBeam: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                let angle = progress * 360 * .pi / 180

                path.move(to: center)
                path.addLine(to: CGPoint(
                    x: center.x + cos(angle) * radius,
                    y: center.y + sin(angle) * radius
                ))
            }
            .stroke(Color.cyan, lineWidth: 2)
            .shadow(color: .cyan, radius: 4)
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.9))
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

        WeatherRadarCard(
            location: Location(
                name: "旧金山",
                latitude: 37.7749,
                longitude: -122.4194,
                timezone: "America/Los_Angeles"
            )
        )
        .padding()
    }
}
