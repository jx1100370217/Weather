# Widget Views

This directory contains weather widget view implementations:

- `SmallWeatherWidget.swift` - Small 2x2 widget
- `MediumWeatherWidget.swift` - Medium 2x4 widget
- `LargeWeatherWidget.swift` - Large 4x4 widget  
- `WidgetGalleryView.swift` - Preview gallery for all widgets

## Note

These widget views are preview implementations. To use them as actual iOS widgets:

1. Create a Widget Extension target in Xcode
2. Copy these view implementations
3. Integrate with WidgetKit Timeline Provider
4. See WIDGET_IMPLEMENTATION_GUIDE.md for complete instructions

## Preview Issues

Due to Swift compiler limitations with complex Preview expressions, 
previews have been disabled in these files. To view widgets:

1. Run the app
2. Navigate to widget gallery (if implemented)
3. Or test via Xcode Widget Extension simulator
