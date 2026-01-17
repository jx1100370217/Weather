//
//  WeatherViewModel.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

/// Main ViewModel for weather app
@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var savedLocations: [Location] = []

    private let weatherService = WeatherService.shared
    private let locationService = LocationService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        loadSavedLocations()
    }

    private func setupBindings() {
        // Monitor location updates
        locationService.$currentLocation
            .compactMap { $0 }
            .removeDuplicates { $0.coordinate.latitude == $1.coordinate.latitude &&
                                $0.coordinate.longitude == $1.coordinate.longitude }
            .sink { [weak self] location in
                Task { @MainActor in
                    await self?.fetchWeatherForCurrentLocation()
                }
            }
            .store(in: &cancellables)

        // Monitor weather service errors
        weatherService.$error
            .compactMap { $0?.errorDescription }
            .assign(to: &$errorMessage)
    }

    /// Request location permission and start updates
    func requestLocationPermission() {
        locationService.requestAuthorization()
    }

    /// Fetch weather for current location
    func fetchWeatherForCurrentLocation() async {
        guard let clLocation = locationService.currentLocation else {
            locationService.requestLocation()
            return
        }

        isLoading = true

        do {
            let locationName = try await locationService.geocodeLocation(clLocation)
            let location = locationService.createLocation(from: clLocation, name: locationName)

            let weather = try await weatherService.fetchWeather(for: location)
            weatherData = weather

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Fetch weather for a specific location
    func fetchWeather(for location: Location) async {
        isLoading = true

        do {
            let weather = try await weatherService.fetchWeather(for: location)
            weatherData = weather
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Add a location to saved locations
    func addLocation(_ location: Location) {
        if !savedLocations.contains(where: { $0.id == location.id }) {
            savedLocations.append(location)
            saveLocations()
        }
    }

    /// Remove a location from saved locations
    func removeLocation(_ location: Location) {
        savedLocations.removeAll { $0.id == location.id }
        saveLocations()
    }

    // MARK: - Persistence

    private func saveLocations() {
        if let encoded = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(encoded, forKey: "SavedLocations")
        }
    }

    private func loadSavedLocations() {
        if let data = UserDefaults.standard.data(forKey: "SavedLocations"),
           let decoded = try? JSONDecoder().decode([Location].self, from: data) {
            savedLocations = decoded
        }
    }

    /// Refresh weather data
    func refresh() async {
        await fetchWeatherForCurrentLocation()
    }
}
