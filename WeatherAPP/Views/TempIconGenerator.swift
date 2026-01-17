//
//  TempIconGenerator.swift
//  WeatherAPP
//
//  临时Icon生成器 - 用于快速测试
//  使用SwiftUI生成简化版app图标
//

import SwiftUI

/// 简化版Icon生成器 - 可以直接在Xcode中截图使用
struct SimplifiedIconPreview: View {
    var body: some View {
        ZStack {
            // 天蓝色渐变背景
            LinearGradient(
                colors: [
                    Color(red: 0.29, green: 0.56, blue: 0.89),
                    Color(red: 0.53, green: 0.81, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // 大太阳符号
            Image(systemName: "sun.max.fill")
                .font(.system(size: 300))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .yellow],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .white.opacity(0.6), radius: 30)
                .offset(x: 80, y: -80)

            // 云朵符号
            Image(systemName: "cloud.fill")
                .font(.system(size: 350))
                .foregroundStyle(.white.opacity(0.6))
                .shadow(color: .white.opacity(0.3), radius: 20, x: -5, y: -5)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 10, y: 10)
                .offset(y: 50)

            // 小雨滴
            Image(systemName: "drop.fill")
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan, .blue],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .cyan.opacity(0.5), radius: 10)
                .offset(x: 200, y: 280)
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview("简化Icon - 1024x1024") {
    SimplifiedIconPreview()
}

#Preview("简化Icon - 圆角") {
    SimplifiedIconPreview()
        .frame(width: 512, height: 512)
        .cornerRadius(113)
        .shadow(radius: 20)
}

// MARK: - 使用说明
/*
 如何生成App Icon：

 1. 在Xcode中打开此文件
 2. 在右侧预览面板中查看 "简化Icon - 1024x1024"
 3. 等待预览加载
 4. 按 Command + Shift + 4 截图
 5. 裁剪为正方形 1024x1024
 6. 访问 https://appicon.co 上传
 7. 下载所有尺寸
 8. 复制到 WeatherAPP/Assets.xcassets/AppIcon.appiconset/

 或者更简单：
 - 在Xcode中右键点击预览
 - 选择 "Export Preview..."
 - 保存为PNG
 */
