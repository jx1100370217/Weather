# 如何生成App Icon

## 方法一：使用Xcode预览截图（推荐）

### 步骤：
1. 在Xcode中打开 `AppIconPreview.swift`
2. 点击右侧的预览面板中的 "App Icon - 1024x1024" 预览
3. 等待预览加载完成
4. 使用macOS截图工具：
   - 按 `Command + Shift + 4`
   - 按空格键切换到窗口截图模式
   - 点击预览窗口截图
5. 将截图裁剪为正方形1024x1024
6. 保存为 `AppIcon-1024.png`

### 使用在线工具生成所有尺寸：
1. 访问 https://appicon.co 或 https://www.appicon.build
2. 上传你的 1024x1024 PNG图片
3. 下载生成的所有尺寸
4. 解压并复制到 `WeatherAPP/Assets.xcassets/AppIcon.appiconset/`

---

## 方法二：使用SF Symbols（快速方案）

如果需要快速测试，可以临时使用SF Symbols图标：

### 步骤：
1. 打开 `WeatherAPP/Assets.xcassets/AppIcon.appiconset/Contents.json`
2. 临时使用系统图标作为app icon
3. 在Info.plist中添加：
```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundlePrimaryIcon</key>
    <dict>
        <key>CFBundleIconName</key>
        <string>cloud.sun.fill</string>
    </dict>
</dict>
```

---

## 方法三：使用Figma/Sketch（专业方案）

### Figma在线设计：
1. 访问 https://www.figma.com
2. 创建 1024x1024 画布
3. 根据 `ICON_DESIGN.md` 中的规格设计：
   - 背景：线性渐变 #4A90E2 → #87CEEB
   - 太阳：白色+黄色径向渐变，右上角
   - 云朵：半透明白色玻璃效果，居中
   - 雨滴：青色渐变，右下角
4. 导出为PNG（1024x1024）
5. 使用方法一中的在线工具生成所有尺寸

---

## 方法四：使用命令行工具（开发者方案）

### 安装ImageMagick：
```bash
brew install imagemagick
```

### 创建基础图标：
```bash
# 创建渐变背景
convert -size 1024x1024 gradient:#4A90E2-#87CEEB base.png

# 添加其他元素需要更复杂的命令...
```

---

## 推荐流程

**最简单的方式：**

1. **运行预览**：在Xcode中打开并运行AppIconPreview
2. **截图**：使用Command+Shift+4截取预览
3. **在线生成**：访问 https://appicon.co 上传截图
4. **替换文件**：将生成的文件复制到项目中

**时间：约5分钟**

---

## 验证Icon是否生成成功

### 在Xcode中检查：
1. 打开 `WeatherAPP/Assets.xcassets/AppIcon.appiconset/`
2. 应该看到以下文件：
   - AppIcon-20@2x.png (40x40)
   - AppIcon-20@3x.png (60x60)
   - AppIcon-29@2x.png (58x58)
   - AppIcon-29@3x.png (87x87)
   - AppIcon-40@2x.png (80x80)
   - AppIcon-40@3x.png (120x120)
   - AppIcon-60@2x.png (120x120)
   - AppIcon-60@3x.png (180x180)
   - AppIcon-76@1x.png (76x76)
   - AppIcon-76@2x.png (152x152)
   - AppIcon-83.5@2x.png (167x167)
   - AppIcon-1024.png (1024x1024)

### 在模拟器中测试：
1. 构建并运行app
2. 按Home键返回主屏幕
3. 查看app图标是否显示正确

---

## 常见问题

**Q: 图标在模拟器中不显示？**
A: 清理构建文件夹（Product > Clean Build Folder），然后重新构建

**Q: 图标边角不是圆角？**
A: iOS会自动添加圆角，不需要在图片中预先裁剪

**Q: 需要透明背景吗？**
A: 不需要，iOS不支持透明App图标

**Q: 图标太暗或太亮？**
A: 可以在AppIconPreview.swift中调整渐变颜色

---

## 快速命令（如果已有1024x1024图标）

如果你已经有一个 `icon-1024.png` 文件：

```bash
# 使用sips命令生成所有尺寸（macOS内置）
cd WeatherAPP/Assets.xcassets/AppIcon.appiconset/

# 示例：生成180x180
sips -z 180 180 icon-1024.png --out AppIcon-60@3x.png

# 生成120x120
sips -z 120 120 icon-1024.png --out AppIcon-60@2x.png

# ... 依次生成其他尺寸
```

但使用在线工具更快更方便！
