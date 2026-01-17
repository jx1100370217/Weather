//
//  GlassCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Reusable glass morphism card component
struct GlassCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.2))
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
            )
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.blue, .purple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        GlassCard {
            Text("Glass Card")
                .foregroundColor(.white)
        }
        .padding()
    }
}
