//
//  UVIndexCard.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

/// UV Index card with health warnings and visual indicators
struct UVIndexCard: View {
    let uvIndex: Int
    @State private var fillProgress: Double = 0

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.yellow)

                    Text("紫外线指数")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }

                HStack(spacing: 20) {
                    // UV Index gauge
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 12)
                            .frame(width: 120, height: 120)

                        // Progress circle
                        Circle()
                            .trim(from: 0, to: fillProgress)
                            .stroke(
                                uvCategory.color,
                                style: StrokeStyle(
                                    lineWidth: 12,
                                    lineCap: .round
                                )
                            )
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                            .shadow(color: uvCategory.color.opacity(0.6), radius: 8)

                        // UV value
                        VStack(spacing: 4) {
                            Text("\(uvIndex)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)

                            Text("UV")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }

                    // UV information
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("等级")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))

                            Text(uvCategory.name)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(uvCategory.color)
                        }

                        Divider()
                            .background(Color.white.opacity(0.3))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("健康建议")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))

                            Text(uvCategory.recommendation)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer()
                }

                // UV scale bar
                UVScaleBar(uvIndex: uvIndex)
                    .frame(height: 8)
                    .cornerRadius(4)
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                fillProgress = min(Double(uvIndex) / 15.0, 1.0)
            }
        }
    }

    private var uvCategory: UVCategory {
        return UVCategory.from(uvIndex: uvIndex)
    }
}

struct UVScaleBar: View {
    let uvIndex: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.green,
                        Color.yellow,
                        Color.orange,
                        Color.red,
                        Color.purple
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(4)

                // Position indicator
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(radius: 2)
                    .offset(x: calculatePosition(for: uvIndex, in: geometry.size.width) - 8)
            }
        }
    }

    private func calculatePosition(for uv: Int, in width: CGFloat) -> CGFloat {
        let maxUV: CGFloat = 15
        let position = CGFloat(min(uv, Int(maxUV))) / maxUV * width
        return min(max(position, 0), width)
    }
}

struct UVCategory {
    let name: String
    let color: Color
    let recommendation: String

    static func from(uvIndex: Int) -> UVCategory {
        switch uvIndex {
        case 0...2:
            return UVCategory(
                name: "低",
                color: .green,
                recommendation: "无需防护，可以安全在外活动"
            )
        case 3...5:
            return UVCategory(
                name: "中等",
                color: .yellow,
                recommendation: "需要防护，建议涂抹防晒霜"
            )
        case 6...7:
            return UVCategory(
                name: "高",
                color: .orange,
                recommendation: "必须防护，避免正午阳光"
            )
        case 8...10:
            return UVCategory(
                name: "很高",
                color: .red,
                recommendation: "额外防护，尽量减少外出"
            )
        default:
            return UVCategory(
                name: "极高",
                color: .purple,
                recommendation: "极端防护，避免外出活动"
            )
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

        UVIndexCard(uvIndex: 8)
            .padding()
    }
}
