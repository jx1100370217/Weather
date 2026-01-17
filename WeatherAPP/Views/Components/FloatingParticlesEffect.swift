//
//  FloatingParticlesEffect.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Premium floating particles effect for clear/sunny weather
struct FloatingParticlesEffect: View {
    let particleCount: Int
    let color: Color

    init(particleCount: Int = 20, color: Color = .white) {
        self.particleCount = particleCount
        self.color = color
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<particleCount, id: \.self) { index in
                    FloatingParticle(
                        geometry: geometry,
                        index: index,
                        color: color
                    )
                }
            }
        }
    }
}

struct FloatingParticle: View {
    let geometry: GeometryProxy
    let index: Int
    let color: Color

    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5

    private let startX: CGFloat
    private let startY: CGFloat
    private let size: CGFloat
    private let duration: Double
    private let delay: Double

    init(geometry: GeometryProxy, index: Int, color: Color) {
        self.geometry = geometry
        self.index = index
        self.color = color
        self.startX = CGFloat.random(in: 0...geometry.size.width)
        self.startY = CGFloat.random(in: 0...geometry.size.height)
        self.size = CGFloat.random(in: 2...6)
        self.duration = Double.random(in: 3...6)
        self.delay = Double.random(in: 0...2)
    }

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        color.opacity(0.8),
                        color.opacity(0.4),
                        color.opacity(0.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .blur(radius: 1)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(x: startX + offset.width, y: startY + offset.height)
            .onAppear {
                // Vertical floating animation
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    offset.height = CGFloat.random(in: -50...50)
                }

                // Horizontal drift
                withAnimation(
                    Animation.easeInOut(duration: duration * 1.5)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    offset.width = CGFloat.random(in: -30...30)
                }

                // Opacity fade in/out
                withAnimation(
                    Animation.easeInOut(duration: duration / 2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    opacity = Double.random(in: 0.3...0.7)
                }

                // Scale pulse
                withAnimation(
                    Animation.easeInOut(duration: duration / 3)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    scale = CGFloat.random(in: 0.7...1.2)
                }
            }
    }
}

/// Shimmer overlay effect for glass surfaces
struct ShimmerEffect: ViewModifier {
    @State private var shimmerOffset: CGFloat = -200
    let enable: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    if enable {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 100)
                            .offset(x: shimmerOffset)
                            .onAppear {
                                withAnimation(
                                    Animation.linear(duration: 2.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(0.5)
                                ) {
                                    shimmerOffset = geometry.size.width + 200
                                }
                            }
                    }
                }
            )
            .clipped()
    }
}

extension View {
    func shimmer(enabled: Bool = true) -> some View {
        modifier(ShimmerEffect(enable: enabled))
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.blue, Color.cyan],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        FloatingParticlesEffect(particleCount: 30, color: .white)

        VStack {
            Spacer()
            Text("Floating Particles Effect")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.2))
                        .shimmer()
                )
            Spacer()
        }
    }
}
