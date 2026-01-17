//
//  WeatherService.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import Foundation
import WeatherKit
import CoreLocation
import Combine

/// Service class to interact with Apple WeatherKit
@MainActor
class WeatherService: ObservableObject {
    static let shared = WeatherService()

    private let weatherService = WeatherKit.WeatherService.shared

    @Published var currentWeatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: WeatherError?

    private init() {}

    /// Fetch weather data for a specific location
    func fetchWeather(for location: Location) async throws -> WeatherData {
        isLoading = true
        defer { isLoading = false }

        do {
            let clLocation = CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )

            // Fetch all weather data
            let weather = try await weatherService.weather(for: clLocation)

            // Convert WeatherKit data to our models
            let currentWeather = convertCurrentWeather(weather.currentWeather)
            let hourlyForecast = convertHourlyForecast(weather.hourlyForecast)
            let dailyForecast = convertDailyForecast(weather.dailyForecast)
            let minutelyPrecipitation = convertMinutelyPrecipitation(weather.minuteForecast)
            let weatherAlerts = convertWeatherAlerts(weather.weatherAlerts)

            let weatherData = WeatherData(
                location: location,
                currentWeather: currentWeather,
                hourlyForecast: hourlyForecast,
                dailyForecast: dailyForecast,
                minutelyPrecipitation: minutelyPrecipitation,
                weatherAlerts: weatherAlerts,
                lastUpdated: Date()
            )

            self.currentWeatherData = weatherData
            return weatherData

        } catch {
            self.error = .apiError(error.localizedDescription)
            throw WeatherError.apiError(error.localizedDescription)
        }
    }

    // MARK: - Conversion Methods

    private func convertCurrentWeather(_ current: WeatherKit.CurrentWeather) -> WeatherAPP.CurrentWeather {
        return WeatherAPP.CurrentWeather(
            temperature: current.temperature.value,
            apparentTemperature: current.apparentTemperature.value,
            condition: mapWeatherCondition(current.condition),
            humidity: current.humidity,
            pressure: current.pressure.value,
            windSpeed: current.wind.speed.value,
            windDirection: current.wind.direction.value,
            uvIndex: current.uvIndex.value,
            visibility: current.visibility.value,
            cloudCover: current.cloudCover,
            dewPoint: current.dewPoint.value
        )
    }

    private func convertHourlyForecast(_ hourly: Forecast<HourWeather>?) -> [WeatherAPP.HourlyWeather] {
        guard let hourly = hourly else { return [] }

        return hourly.prefix(24).map { hour in
            WeatherAPP.HourlyWeather(
                date: hour.date,
                temperature: hour.temperature.value,
                condition: mapWeatherCondition(hour.condition),
                precipitationChance: hour.precipitationChance,
                precipitationAmount: hour.precipitationAmount.value,
                windSpeed: hour.wind.speed.value,
                humidity: hour.humidity
            )
        }
    }

    private func convertDailyForecast(_ daily: Forecast<DayWeather>?) -> [WeatherAPP.DailyWeather] {
        guard let daily = daily else { return [] }

        return daily.prefix(15).map { day in
            WeatherAPP.DailyWeather(
                date: day.date,
                highTemperature: day.highTemperature.value,
                lowTemperature: day.lowTemperature.value,
                condition: mapWeatherCondition(day.condition),
                precipitationChance: day.precipitationChance,
                sunrise: day.sun.sunrise ?? day.date,
                sunset: day.sun.sunset ?? day.date,
                moonPhase: convertMoonPhase(day.moon.phase),
                uvIndex: day.uvIndex.value
            )
        }
    }

    private func convertMoonPhase(_ phase: MoonPhase) -> Double {
        // Convert MoonPhase to a 0.0-1.0 value
        // This is an approximation based on the phase
        switch phase {
        case .new: return 0.0
        case .waxingCrescent: return 0.125
        case .firstQuarter: return 0.25
        case .waxingGibbous: return 0.375
        case .full: return 0.5
        case .waningGibbous: return 0.625
        case .lastQuarter: return 0.75
        case .waningCrescent: return 0.875
        @unknown default: return 0.0
        }
    }

    private func convertMinutelyPrecipitation(_ minutely: Forecast<MinuteWeather>?) -> [WeatherAPP.MinutelyPrecipitation]? {
        guard let minutely = minutely else { return nil }

        return minutely.map { minute in
            WeatherAPP.MinutelyPrecipitation(
                date: minute.date,
                precipitationIntensity: minute.precipitationIntensity.value,
                precipitationChance: minute.precipitationChance
            )
        }
    }

    private func convertWeatherAlerts(_ alerts: [WeatherKit.WeatherAlert]?) -> [WeatherAPP.WeatherAlert] {
        guard let alerts = alerts else { return [] }

        return alerts.map { alert in
            WeatherAPP.WeatherAlert(
                severity: mapAlertSeverity(alert.severity),
                title: alert.summary,
                description: alert.detailsURL.absoluteString,
                startDate: Date(), // WeatherKit doesn't provide onset/expires in current API
                endDate: Date().addingTimeInterval(86400)
            )
        }
    }

    // MARK: - Mapping Functions

    private func mapWeatherCondition(_ condition: WeatherKit.WeatherCondition) -> WeatherAPP.WeatherCondition {
        switch condition {
        case .clear: return .clear
        case .mostlyClear: return .mostlyClear
        case .partlyCloudy: return .partlyCloudy
        case .mostlyCloudy: return .mostlyCloudy
        case .cloudy: return .cloudy
        case .foggy: return .foggy
        case .drizzle: return .drizzle
        case .rain: return .rain
        case .heavyRain: return .heavyRain
        case .sunShowers: return .rain
        case .snow: return .snow
        case .heavySnow: return .heavySnow
        case .sleet: return .sleet
        case .hail: return .hail
        case .windy: return .windy
        case .smoky: return .smoky
        case .blowingDust: return .clear
        case .freezingDrizzle: return .drizzle
        case .freezingRain: return .rain
        case .flurries: return .snow
        case .sunFlurries: return .snow
        case .scatteredThunderstorms: return .rain
        case .strongStorms: return .rain
        case .thunderstorms: return .rain
        case .isolatedThunderstorms: return .rain
        case .tropicalStorm: return .rain
        case .hurricane: return .rain
        case .blizzard: return .heavySnow
        case .blowingSnow: return .snow
        case .wintryMix: return .sleet
        case .hot: return .clear
        case .frigid: return .clear
        case .haze: return .foggy
        case .breezy: return .windy
        @unknown default: return .clear
        }
    }

    private func mapAlertSeverity(_ severity: WeatherSeverity) -> WeatherAPP.AlertSeverity {
        switch severity {
        case .minor: return .minor
        case .moderate: return .moderate
        case .severe: return .severe
        case .extreme: return .extreme
        case .unknown: return .moderate
        @unknown default: return .moderate
        }
    }
}

/// Weather-related errors
enum WeatherError: LocalizedError {
    case locationDenied
    case apiError(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .locationDenied:
            return "位置访问被拒绝。请在设置中允许位置访问。"
        case .apiError(let message):
            return "天气数据获取失败: \(message)"
        case .unknown:
            return "未知错误"
        }
    }
}
