# Aether Weather (天辉) ☀️🌧️❄️

An immersive, beautiful iOS weather application that brings weather data to life with stunning visualizations and intuitive design.

![Platform](https://img.shields.io/badge/platform-iOS%2017.0%2B-blue)
![Language](https://img.shields.io/badge/language-Swift%205-orange)
![Framework](https://img.shields.io/badge/framework-SwiftUI-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## ✨ Features

### Core Weather Data
- 🌡️ **Real-time Weather** - Current temperature, conditions, and feel-like temperature
- ⏱️ **Minute-by-Minute Precipitation** - Know exactly when it will rain
- 📅 **24-Hour Forecast** - Hourly weather predictions
- 📊 **15-Day Forecast** - Extended weather outlook
- 📍 **Location-based** - Automatic weather for your current location

### Immersive UI/UX
- 🎨 **Dynamic Backgrounds** - Beautiful weather-reactive gradients
- 💧 **Animated Effects** - Realistic rain, snow, and cloud animations
- 🪟 **Glass Morphism** - Frosted glass UI elements
- 🌓 **Day/Night Themes** - Automatic theme switching
- 📱 **Native iOS Design** - Follows Apple Human Interface Guidelines

### Advanced Features
- 🔍 **Detailed Metrics** - Humidity, wind, pressure, UV index, visibility
- 🌅 **Sun & Moon** - Sunrise/sunset times and moon phases
- 📱 **Widget Support** - Small, Medium, and Large widgets (preview implementation)
- ⚡ **Pull to Refresh** - Easy data updates
- 💾 **Offline Caching** - View last known weather without internet

## 🏗️ Architecture

Built with modern iOS development best practices:

- **MVVM Pattern** - Clear separation of concerns
- **SwiftUI** - Declarative, reactive UI
- **Combine** - Reactive data binding
- **WeatherKit** - Apple's native weather API
- **CoreLocation** - Precise location services

## 📁 Project Structure

```
WeatherAPP/
├── Models/
│   └── WeatherData.swift          # Data models
├── Services/
│   ├── WeatherService.swift       # WeatherKit integration
│   └── LocationService.swift      # Location management
├── ViewModels/
│   └── WeatherViewModel.swift     # Business logic
├── Views/
│   ├── MainWeatherView.swift      # Main screen
│   ├── WeatherBackgroundView.swift # Dynamic backgrounds
│   ├── Components/                # Reusable UI components
│   └── Widgets/                   # Widget implementations
└── Assets.xcassets/               # Images and colors
```

## 🚀 Getting Started

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Apple Developer Account (for WeatherKit)

### Installation

1. Clone the repository
```bash
git clone https://github.com/jx1100370217/Weather.git
cd Weather
```

2. Open in Xcode
```bash
open WeatherAPP.xcodeproj
```

3. Configure WeatherKit
   - Sign in with your Apple Developer account
   - Enable WeatherKit capability in Signing & Capabilities
   - Select your development team

4. Build and run
   - Select an iOS simulator or device
   - Press Cmd+R to build and run

### WeatherKit Setup

1. **Apple Developer Account Required**
   - WeatherKit requires a paid Apple Developer Program membership ($99/year)
   - Sign in to your account in Xcode preferences

2. **Enable WeatherKit**
   - Select the WeatherAPP target
   - Go to Signing & Capabilities
   - Click "+ Capability"
   - Add "WeatherKit"

3. **Location Permissions**
   - The app will request location permission on first launch
   - Grant "While Using App" or "Always" permission

## 📱 Screenshots

### Main Weather View
- Dynamic weather background
- Current temperature and conditions
- Minute-by-minute precipitation chart
- Hourly forecast slider
- Detailed weather metrics

### Widget Gallery
- Small widget (2x2)
- Medium widget (2x4)
- Large widget (4x4)

## 🛠️ Technical Details

### Data Flow
```
LocationService → Get User Location
       ↓
WeatherService → Fetch Weather from WeatherKit
       ↓
WeatherViewModel → Process and Cache Data
       ↓
Views → Display Beautiful UI
```

### Key Technologies
- **SwiftUI** - Modern declarative UI framework
- **Combine** - Reactive programming for data flow
- **WeatherKit** - Apple's weather data service
- **CoreLocation** - GPS and location services
- **UserDefaults** - Local data persistence

### Performance
- ⚡ Cold start < 1.5 seconds
- 💾 Cached display < 0.2 seconds
- 📦 App size < 50MB
- 🔋 Battery efficient background updates

## 📖 Documentation

- [PRD.md](prd.md) - Complete Product Requirements Document
- [DEVELOPMENT_SUMMARY.md](DEVELOPMENT_SUMMARY.md) - Implementation details
- [WIDGET_IMPLEMENTATION_GUIDE.md](WIDGET_IMPLEMENTATION_GUIDE.md) - Widget setup guide

## 🔮 Roadmap

### Phase 1: Core Enhancement
- [ ] Widget Extension with WidgetKit
- [ ] Multiple city management
- [ ] Background data refresh
- [ ] Push notifications for alerts

### Phase 2: Advanced Features
- [ ] Dynamic Island support (iPhone 14 Pro+)
- [ ] Live Activities for lock screen
- [ ] Interactive weather radar
- [ ] Life index recommendations

### Phase 3: Platform Expansion
- [ ] Apple Watch app
- [ ] iPad optimization
- [ ] macOS app (Catalyst)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple WeatherKit for weather data
- SF Symbols for beautiful icons
- SwiftUI for amazing UI framework
- The iOS developer community

## 📞 Contact

- **Developer**: jx1100370217
- **Repository**: [github.com/jx1100370217/Weather](https://github.com/jx1100370217/Weather)
- **Issues**: [GitHub Issues](https://github.com/jx1100370217/Weather/issues)

## ⚠️ Important Notes

1. **WeatherKit API**: Requires Apple Developer Program membership
2. **Location Access**: Needed for weather data
3. **Internet Connection**: Required for real-time updates
4. **iOS Version**: Minimum iOS 17.0 required

## 🌟 Star History

If you find this project helpful, please give it a ⭐ on GitHub!

---

Made with ❤️ using SwiftUI and WeatherKit

Last Updated: 2026-01-17
