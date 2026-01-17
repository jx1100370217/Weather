//
//  WeatherData.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import Foundation
import WeatherKit

/// Main weather data model containing all weather information
struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let location: Location
    let currentWeather: CurrentWeather
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyWeather]
    let minutelyPrecipitation: [MinutelyPrecipitation]?
    let weatherAlerts: [WeatherAlert]
    let airQuality: AirQuality?
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case location, currentWeather, hourlyForecast, dailyForecast
        case minutelyPrecipitation, weatherAlerts, airQuality, lastUpdated
    }
}

/// Location information
struct Location: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case name, latitude, longitude, timezone
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

/// Current weather conditions
struct CurrentWeather: Codable {
    let temperature: Double
    let apparentTemperature: Double
    let condition: WeatherCondition
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windDirection: Double
    let uvIndex: Int
    let visibility: Double
    let cloudCover: Double
    let dewPoint: Double
}

/// Hourly weather forecast
struct HourlyWeather: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let temperature: Double
    let condition: WeatherCondition
    let precipitationChance: Double
    let precipitationAmount: Double
    let windSpeed: Double
    let humidity: Double

    enum CodingKeys: String, CodingKey {
        case date, temperature, condition, precipitationChance
        case precipitationAmount, windSpeed, humidity
    }
}

/// Daily weather forecast
struct DailyWeather: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let highTemperature: Double
    let lowTemperature: Double
    let condition: WeatherCondition
    let precipitationChance: Double
    let sunrise: Date
    let sunset: Date
    let moonPhase: Double
    let uvIndex: Int

    enum CodingKeys: String, CodingKey {
        case date, highTemperature, lowTemperature, condition
        case precipitationChance, sunrise, sunset, moonPhase, uvIndex
    }
}

/// Minute-by-minute precipitation forecast
struct MinutelyPrecipitation: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let precipitationIntensity: Double
    let precipitationChance: Double

    enum CodingKeys: String, CodingKey {
        case date, precipitationIntensity, precipitationChance
    }
}

/// Weather alert/warning
struct WeatherAlert: Codable, Identifiable {
    let id = UUID()
    let severity: AlertSeverity
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date

    enum CodingKeys: String, CodingKey {
        case severity, title, description, startDate, endDate
    }
}

enum AlertSeverity: String, Codable {
    case minor
    case moderate
    case severe
    case extreme
}

/// Air Quality data
struct AirQuality: Codable {
    let aqi: Int
    let category: String
    let pollutants: [String: Double]
    let dominantPollutant: String?

    var aqiCategory: AQICategory {
        return AQICategory.from(aqi: aqi)
    }
}

/// AQI Category for display
enum AQICategory: String, Codable {
    case good = "优"
    case moderate = "良"
    case unhealthyForSensitive = "轻度污染"
    case unhealthy = "中度污染"
    case veryUnhealthy = "重度污染"
    case hazardous = "严重污染"

    static func from(aqi: Int) -> AQICategory {
        switch aqi {
        case 0...50: return .good
        case 51...100: return .moderate
        case 101...150: return .unhealthyForSensitive
        case 151...200: return .unhealthy
        case 201...300: return .veryUnhealthy
        default: return .hazardous
        }
    }
}

/// Weather condition types
enum WeatherCondition: String, Codable {
    case clear
    case mostlyClear
    case partlyCloudy
    case mostlyCloudy
    case cloudy
    case foggy
    case drizzle
    case rain
    case heavyRain
    case snow
    case heavySnow
    case sleet
    case hail
    case thunderstorm
    case windy
    case smoky

    var displayName: String {
        switch self {
        case .clear: return "晴朗"
        case .mostlyClear: return "大部晴朗"
        case .partlyCloudy: return "局部多云"
        case .mostlyCloudy: return "大部多云"
        case .cloudy: return "阴天"
        case .foggy: return "雾"
        case .drizzle: return "毛毛雨"
        case .rain: return "雨"
        case .heavyRain: return "大雨"
        case .snow: return "雪"
        case .heavySnow: return "大雪"
        case .sleet: return "雨夹雪"
        case .hail: return "冰雹"
        case .thunderstorm: return "雷暴"
        case .windy: return "大风"
        case .smoky: return "烟雾"
        }
    }

    var systemIconName: String {
        switch self {
        case .clear: return "sun.max.fill"
        case .mostlyClear: return "sun.max"
        case .partlyCloudy: return "cloud.sun.fill"
        case .mostlyCloudy: return "cloud.sun"
        case .cloudy: return "cloud.fill"
        case .foggy: return "cloud.fog.fill"
        case .drizzle: return "cloud.drizzle.fill"
        case .rain: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .snow: return "cloud.snow.fill"
        case .heavySnow: return "cloud.snow.fill"
        case .sleet: return "cloud.sleet.fill"
        case .hail: return "cloud.hail.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .windy: return "wind"
        case .smoky: return "smoke.fill"
        }
    }
}
