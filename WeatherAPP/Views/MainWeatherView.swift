//
//  MainWeatherView.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import SwiftUI

struct MainWeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showingLocationPermission = false

    var body: some View {
        ZStack {
            // Dynamic background
            if let weather = viewModel.weatherData {
                WeatherBackgroundView(
                    condition: weather.currentWeather.condition,
                    isDaytime: isDaytime(weather: weather)
                )
            } else {
                WeatherBackgroundView(condition: .clear, isDaytime: true)
            }

            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                            .padding(.top, 100)
                    } else if let weather = viewModel.weatherData {
                        weatherContent(weather: weather)
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
                    } else {
                        welcomeView
                    }
                }
                .padding(.horizontal)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }

    // MARK: - Weather Content

    @ViewBuilder
    private func weatherContent(weather: WeatherData) -> some View {
        VStack(spacing: 20) {
            // Location and current temperature with enhanced animations
            VStack(spacing: 8) {
                Text(weather.location.name)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .transition(.opacity.combined(with: .scale))

                Text("\(Int(weather.currentWeather.temperature))°")
                    .font(.system(size: 96, weight: .thin))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                    .contentTransition(.numericText())
                    .transition(.opacity.combined(with: .scale))

                Text(weather.currentWeather.condition.displayName)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

                HStack(spacing: 4) {
                    Text("最高 \(Int(weather.dailyForecast.first?.highTemperature ?? 0))°")
                    Text("•")
                    Text("最低 \(Int(weather.dailyForecast.first?.lowTemperature ?? 0))°")
                }
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                .transition(.opacity)
            }
            .padding(.top, 60)

            // Minute-by-minute precipitation
            if let minutely = weather.minutelyPrecipitation, !minutely.isEmpty {
                MinutelyPrecipitationCard(data: minutely)
            }

            // Air Quality (new feature!)
            if let airQuality = weather.airQuality {
                AirQualityCard(airQuality: airQuality)
            }

            // Weather Radar (new feature!)
            WeatherRadarCard(location: weather.location)

            // Hourly forecast
            HourlyForecastCard(hourly: weather.hourlyForecast)

            // Daily forecast
            DailyForecastCard(daily: weather.dailyForecast)

            // Weather details
            WeatherDetailsCard(current: weather.currentWeather)

            // Sun and moon
            if let daily = weather.dailyForecast.first {
                SunMoonCard(daily: daily)
            }

            Spacer(minLength: 40)
        }
    }

    private var welcomeView: some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)

            Text("欢迎使用 Aether")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            Text("请允许访问位置以获取天气信息")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(action: {
                viewModel.requestLocationPermission()
            }) {
                Text("授权位置访问")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(16)
            }
        }
        .padding(.top, 100)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)

            Text("出错了")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            Text(message)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button(action: {
                Task {
                    await viewModel.refresh()
                }
            }) {
                Text("重试")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(16)
            }
        }
        .padding(.top, 100)
    }

    // MARK: - Helper Methods

    private func isDaytime(weather: WeatherData) -> Bool {
        guard let daily = weather.dailyForecast.first else {
            let hour = Calendar.current.component(.hour, from: Date())
            return hour >= 6 && hour < 18
        }

        let now = Date()
        return now >= daily.sunrise && now <= daily.sunset
    }
}

#Preview {
    MainWeatherView()
}
