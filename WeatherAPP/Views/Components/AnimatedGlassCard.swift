//
//  AnimatedGlassCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Enhanced glass card with shimmer and pulse animations for premium feel
struct AnimatedGlassCard<Content: View>: View {
    let content: Content
    let enableShimmer: Bool
    let enablePulse: Bool

    @State private var isVisible = false
    @State private var shimmerOffset: CGFloat = -200
    @State private var pulseScale: CGFloat = 1.0

    init(
        enableShimmer: Bool = false,
        enablePulse: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.enableShimmer = enableShimmer
        self.enablePulse = enablePulse
    }

    var body: some View {
        content
            .padding()
            .background(
                ZStack {
                    // Base glass layer with enhanced gradient
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 24)
                        )

                    // Shimmer effect overlay
                    if enableShimmer {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: shimmerOffset)
                            .mask(RoundedRectangle(cornerRadius: 24))
                    }

                    // Multi-layered border for depth
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )

                    // Glowing inner highlights
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 250
                            )
                        )

                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.clear
                                ],
                                center: .bottomTrailing,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.2), radius: 25, x: 0, y: 12)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: -2)
            .scaleEffect(enablePulse ? pulseScale : (isVisible ? 1.0 : 0.95))
            .opacity(isVisible ? 1.0 : 0)
            .onAppear {
                // Entrance animation
                withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                    isVisible = true
                }

                // Shimmer animation
                if enableShimmer {
                    withAnimation(
                        Animation.linear(duration: 2.5)
                            .repeatForever(autoreverses: false)
                            .delay(0.5)
                    ) {
                        shimmerOffset = 400
                    }
                }

                // Pulse animation
                if enablePulse {
                    withAnimation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        pulseScale = 1.02
                    }
                }
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

        VStack(spacing: 20) {
            AnimatedGlassCard(enableShimmer: true) {
                VStack {
                    Text("Shimmer Effect")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Premium glass card with shimmer")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
            }

            AnimatedGlassCard(enablePulse: true) {
                VStack {
                    Text("Pulse Effect")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Subtle breathing animation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
            }

            AnimatedGlassCard(enableShimmer: true, enablePulse: true) {
                VStack {
                    Text("Combined Effects")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("Shimmer + Pulse")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}
