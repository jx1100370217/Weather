# Weather Widget Implementation Guide

## Overview
This guide outlines how to add Widget Extension support to the Aether Weather app.

## Prerequisites
- Xcode 15.0 or later
- iOS 17.0+ deployment target
- Apple Developer Account (for WeatherKit entitlements)

## Steps to Add Widget Extension

### 1. Create Widget Extension Target
1. Open `WeatherAPP.xcodeproj` in Xcode
2. File → New → Target
3. Select "Widget Extension"
4. Product Name: "WeatherWidget"
5. Ensure "Include Configuration Intent" is checked
6. Click Finish
7. Activate the scheme when prompted

### 2. Configure Widget Capabilities
1. Select WeatherWidget target
2. Signing & Capabilities tab
3. Add "WeatherKit" capability
4. Add "App Groups" capability (use: `group.com.yourcompany.weatherapp`)

### 3. Share Data Models
1. Select `WeatherData.swift`, `Location.swift` in Project Navigator
2. In File Inspector, add to WeatherWidget target membership
3. Do the same for `WeatherService.swift` and related files

### 4. Implement Widget Timeline Provider
Use the timeline provider pattern to fetch and update weather data periodically.

### 5. Create Widget Configurations
Create three widget sizes:
- **Small (2x2)**: Current temperature and condition icon
- **Medium (2x4)**: Current weather + hourly forecast
- **Large (4x4)**: Full weather details with daily forecast

### 6. Add Lock Screen Widgets (iOS 16+)
Create circular and rectangular lock screen widget families.

### 7. Configure Background Refresh
Set up background refresh intervals:
- Minimum: 15 minutes (iOS system limit)
- Recommended: 30 minutes (balance freshness vs battery)

## Widget Data Management

### Shared User Defaults
Create an App Group to share data between main app and widget:

```swift
extension UserDefaults {
    static let shared = UserDefaults(suiteName: "group.com.yourcompany.weatherapp")!
}
```

### Weather Data Caching
Cache the latest weather data in shared UserDefaults so widgets can display it without making API calls.

## Widget Code Structure

```
WeatherWidget/
├── WeatherWidget.swift          # Main widget definition
├── WeatherWidgetEntryView.swift # Widget UI views
├── WeatherTimelineProvider.swift# Timeline provider
└── Assets.xcassets/             # Widget-specific assets
```

## Important Notes

1. **WeatherKit Limitations**: Widgets cannot directly call WeatherKit. The main app must fetch weather data and share it via App Groups.

2. **Update Frequency**: iOS controls widget update frequency. Don't expect real-time updates.

3. **Battery Optimization**: Minimize widget updates to conserve battery. Use smart refresh strategies.

4. **Size Constraints**: Design widgets to be readable at small sizes. Use concise text and clear icons.

5. **Testing**: Test widgets on actual devices. Simulator behavior may differ.

## Next Steps for Development

1. Create the Widget Extension target in Xcode
2. Implement the widget views based on the designs in PRD
3. Set up App Group for data sharing
4. Modify main app to cache weather data for widgets
5. Test on physical device
6. Submit to App Store

## Widget Preview Implementation

For demonstration purposes, we've created widget preview views that can be displayed in the main app. These use the same UI components that would be used in actual widgets.

To convert these to real widgets later:
1. Follow the steps above to create a Widget Extension
2. Copy the widget view code from the preview files
3. Integrate with the Timeline Provider
4. Configure entitlements and capabilities
