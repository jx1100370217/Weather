//
//  AppIconPreview.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//
//  This file provides a SwiftUI preview of the app icon design.
//  Screenshot this preview at 1024x1024 to create the actual app icon.
//

import SwiftUI

/// Preview of the app icon design - screenshot this for the actual icon
struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.29, green: 0.56, blue: 0.89), // #4A90E2
                    Color(red: 0.53, green: 0.81, blue: 0.92)  // #87CEEB
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Sun element (top-right)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white,
                            Color.yellow.opacity(0.8),
                            Color.orange.opacity(0.0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .blur(radius: 4)
                .offset(x: 140, y: -140)

            // Sun core
            Circle()
                .fill(Color.white)
                .frame(width: 80, height: 80)
                .shadow(color: .yellow.opacity(0.6), radius: 20)
                .offset(x: 140, y: -140)

            // Central glass cloud
            ZStack {
                // Cloud shape
                CloudShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.4),
                                Color.white.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 420, height: 280)
                    .shadow(color: .white.opacity(0.3), radius: 15, x: -8, y: -8)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 10, y: 10)

                // Cloud border
                CloudShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 420, height: 280)

                // Inner glow
                CloudShape()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                    .frame(width: 420, height: 280)
            }
            .offset(y: -20)

            // Raindrop elements
            ForEach(0..<3, id: \.self) { index in
                RaindropShape()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.cyan.opacity(0.7),
                                Color.blue.opacity(0.5)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 40, height: 60)
                    .shadow(color: .cyan.opacity(0.4), radius: 8)
                    .offset(
                        x: CGFloat(index - 1) * 80 + 60,
                        y: 160 + CGFloat(index) * 20
                    )
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

/// Cloud shape for the app icon
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Cloud outline using curves
        path.move(to: CGPoint(x: width * 0.25, y: height * 0.5))

        // Left side
        path.addCurve(
            to: CGPoint(x: width * 0.15, y: height * 0.35),
            control1: CGPoint(x: width * 0.15, y: height * 0.5),
            control2: CGPoint(x: width * 0.1, y: height * 0.4)
        )

        // Top left bump
        path.addCurve(
            to: CGPoint(x: width * 0.35, y: height * 0.2),
            control1: CGPoint(x: width * 0.15, y: height * 0.25),
            control2: CGPoint(x: width * 0.25, y: height * 0.2)
        )

        // Top center bump
        path.addCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.2),
            control1: CGPoint(x: width * 0.45, y: height * 0.15),
            control2: CGPoint(x: width * 0.55, y: height * 0.15)
        )

        // Top right bump
        path.addCurve(
            to: CGPoint(x: width * 0.85, y: height * 0.35),
            control1: CGPoint(x: width * 0.75, y: height * 0.2),
            control2: CGPoint(x: width * 0.85, y: height * 0.25)
        )

        // Right side
        path.addCurve(
            to: CGPoint(x: width * 0.75, y: height * 0.5),
            control1: CGPoint(x: width * 0.9, y: height * 0.4),
            control2: CGPoint(x: width * 0.85, y: height * 0.5)
        )

        // Bottom
        path.addCurve(
            to: CGPoint(x: width * 0.25, y: height * 0.5),
            control1: CGPoint(x: width * 0.65, y: height * 0.55),
            control2: CGPoint(x: width * 0.35, y: height * 0.55)
        )

        path.closeSubpath()
        return path
    }
}

/// Raindrop shape for the app icon
struct RaindropShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Start at top point
        path.move(to: CGPoint(x: width * 0.5, y: 0))

        // Right curve
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height),
            control1: CGPoint(x: width * 0.85, y: height * 0.3),
            control2: CGPoint(x: width * 0.7, y: height * 0.7)
        )

        // Left curve
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control1: CGPoint(x: width * 0.3, y: height * 0.7),
            control2: CGPoint(x: width * 0.15, y: height * 0.3)
        )

        path.closeSubpath()
        return path
    }
}

#Preview("App Icon - 1024x1024") {
    AppIconPreview()
        .frame(width: 1024, height: 1024)
}

#Preview("App Icon - Rounded") {
    AppIconPreview()
        .frame(width: 512, height: 512)
        .cornerRadius(113) // iOS app icon corner radius
        .shadow(radius: 20)
}
