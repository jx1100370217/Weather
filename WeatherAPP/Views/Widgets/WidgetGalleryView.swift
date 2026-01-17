//
//  WidgetGalleryView.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// Gallery view to preview all widget sizes
struct WidgetGalleryView: View {
    let weather: WeatherData

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("小组件预览")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text("以下是各种尺寸的天气小组件预览。\n实际小组件需要通过 Widget Extension 实现。")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Small Widget
                VStack(spacing: 12) {
                    Text("小尺寸 (2x2)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    SmallWeatherWidget(weather: weather)
                }

                // Medium Widget
                VStack(spacing: 12) {
                    Text("中尺寸 (2x4)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    MediumWeatherWidget(weather: weather)
                }

                // Large Widget
                VStack(spacing: 12) {
                    Text("大尺寸 (4x4)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    LargeWeatherWidget(weather: weather)
                }

                // Implementation note
                VStack(spacing: 12) {
                    Text("实现说明")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("• 这些是小组件的UI预览")
                        Text("• 要在主屏幕使用，需要创建 Widget Extension")
                        Text("• 支持锁屏小组件（iOS 16+）")
                        Text("• 支持灵动岛集成（iPhone 14 Pro+）")
                        Text("• 详见 WIDGET_IMPLEMENTATION_GUIDE.md")
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal)
                }

                Spacer(minLength: 40)
            }
        }
        .background(
            LinearGradient(
                colors: [Color(hex: "4A90E2"), Color(hex: "2C3E50")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}


// Preview removed due to compiler type-checking complexity
