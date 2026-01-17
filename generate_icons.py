#!/usr/bin/env python3
"""
自动生成Weather App的所有尺寸Icon
运行: python3 generate_icons.py
"""

from PIL import Image, ImageDraw, ImageFilter
import os

# 颜色定义
SKY_BLUE_TOP = (74, 144, 226)      # #4A90E2
SKY_BLUE_BOTTOM = (135, 206, 235)  # #87CEEB
YELLOW = (255, 215, 0)
WHITE = (255, 255, 255)
CYAN = (0, 212, 255)

def create_gradient(draw, width, height, color1, color2):
    """创建垂直渐变"""
    for y in range(height):
        ratio = y / height
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
        draw.line([(0, y), (width, y)], fill=(r, g, b))

def create_icon_1024():
    """创建1024x1024的主icon"""
    size = 1024
    img = Image.new('RGB', (size, size), SKY_BLUE_TOP)
    draw = ImageDraw.Draw(img)

    # 背景渐变
    create_gradient(draw, size, size, SKY_BLUE_TOP, SKY_BLUE_BOTTOM)

    # 太阳 (右上角)
    sun_center = (size * 0.75, size * 0.25)
    sun_radius = size * 0.15

    # 太阳外圈光晕
    for i in range(10):
        opacity = int(255 * (1 - i / 10) * 0.3)
        color = (*YELLOW, opacity)
        radius = sun_radius + i * 5
        draw.ellipse(
            [sun_center[0] - radius, sun_center[1] - radius,
             sun_center[0] + radius, sun_center[1] + radius],
            fill=(YELLOW[0], YELLOW[1], YELLOW[2])
        )

    # 太阳核心
    draw.ellipse(
        [sun_center[0] - sun_radius, sun_center[1] - sun_radius,
         sun_center[0] + sun_radius, sun_center[1] + sun_radius],
        fill=WHITE
    )

    # 云朵 (中心，简化为椭圆组合)
    cloud_y = size * 0.45
    cloud_color = (255, 255, 255, 180)

    # 云朵主体
    draw.ellipse(
        [size * 0.25, cloud_y, size * 0.75, cloud_y + size * 0.25],
        fill=(255, 255, 255)
    )

    # 云朵凸起
    draw.ellipse(
        [size * 0.3, cloud_y - size * 0.08, size * 0.5, cloud_y + size * 0.12],
        fill=(255, 255, 255)
    )
    draw.ellipse(
        [size * 0.5, cloud_y - size * 0.1, size * 0.7, cloud_y + size * 0.1],
        fill=(255, 255, 255)
    )

    # 雨滴 (右下角)
    raindrop_x = size * 0.7
    raindrop_y = size * 0.75
    raindrop_size = size * 0.08

    # 绘制3个雨滴
    for i in range(3):
        x = raindrop_x + i * raindrop_size * 0.8
        y = raindrop_y + i * raindrop_size * 0.3

        # 雨滴形状（简化为椭圆）
        draw.ellipse(
            [x, y, x + raindrop_size * 0.5, y + raindrop_size],
            fill=CYAN
        )

    return img

def generate_all_sizes():
    """生成所有需要的icon尺寸"""
    sizes = {
        'AppIcon-20@2x.png': 40,
        'AppIcon-20@3x.png': 60,
        'AppIcon-29@2x.png': 58,
        'AppIcon-29@3x.png': 87,
        'AppIcon-40@2x.png': 80,
        'AppIcon-40@3x.png': 120,
        'AppIcon-60@2x.png': 120,
        'AppIcon-60@3x.png': 180,
        'AppIcon-76@1x.png': 76,
        'AppIcon-76@2x.png': 152,
        'AppIcon-83.5@2x.png': 167,
        'AppIcon-1024.png': 1024,
    }

    # 创建输出目录
    output_dir = 'WeatherAPP/Assets.xcassets/AppIcon.appiconset'
    os.makedirs(output_dir, exist_ok=True)

    print("🎨 开始生成Weather App图标...")

    # 创建主图标
    print("   生成1024x1024主图标...")
    master_icon = create_icon_1024()

    # 生成所有尺寸
    for filename, size in sizes.items():
        print(f"   生成 {filename} ({size}x{size})...")
        resized = master_icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(os.path.join(output_dir, filename))

    print("✅ 所有图标生成完成！")
    print(f"   输出目录: {output_dir}")
    print("\n下一步: 在Xcode中构建项目即可看到新图标")

if __name__ == '__main__':
    # 检查PIL是否安装
    try:
        generate_all_sizes()
    except ImportError:
        print("❌ 错误: 需要安装Pillow库")
        print("   请运行: pip3 install Pillow")
        print("   然后重新运行此脚本")
    except Exception as e:
        print(f"❌ 生成图标时出错: {e}")
