//
//  LocationService.swift
//  WeatherAPP
//
//  Created by Claude on 2026/1/17.
//

import Foundation
import CoreLocation
import MapKit
import Combine

/// Service class to handle location updates
@MainActor
class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()

    @Published var currentLocation: CLLocation?
    @Published var locationName: String?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var error: LocationError?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000 // Update every 1km
        authorizationStatus = locationManager.authorizationStatus
    }

    /// Request location authorization
    func requestAuthorization() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // Already authorized, start getting location
            requestLocation()
        case .denied, .restricted:
            error = .authorizationDenied
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    /// Start updating location
    func startUpdatingLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            error = .authorizationDenied
            return
        }
        locationManager.startUpdatingLocation()
    }

    /// Stop updating location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    /// Get current location once
    func requestLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            error = .authorizationDenied
            return
        }
        locationManager.requestLocation()
    }

    /// Geocode location to get city name using CLGeocoder
    func geocodeLocation(_ location: CLLocation) async throws -> String {
        // Generate coordinate-based fallback name
        let coordinateName = generateCoordinateName(for: location)

        let geocoder = CLGeocoder()

        do {
            // Use a timeout to avoid long waits
            let placemarks = try await withTimeout(seconds: 3) {
                try await geocoder.reverseGeocodeLocation(location)
            }

            // Extract city name from placemark
            if let placemark = placemarks.first {
                // Priority: locality (city) > administrativeArea (province/state) > country
                if let city = placemark.locality, !city.isEmpty {
                    return city
                } else if let area = placemark.administrativeArea, !area.isEmpty {
                    return area
                } else if let subArea = placemark.subAdministrativeArea, !subArea.isEmpty {
                    return subArea
                } else if let country = placemark.country, !country.isEmpty {
                    return country
                }
            }

            // No results, use coordinate-based name
            return coordinateName

        } catch {
            // Silently fail and use coordinates (common in simulator)
            return coordinateName
        }
    }

    /// Generate a readable name from coordinates
    private func generateCoordinateName(for location: CLLocation) -> String {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        // Simple region detection based on coordinates
        let absLat = abs(lat)
        let absLon = abs(lon)

        // San Francisco area (common simulator default)
        if absLat > 37.0 && absLat < 38.0 && absLon > 122.0 && absLon < 123.0 {
            return "旧金山湾区"
        }

        // Beijing area
        if absLat > 39.0 && absLat < 41.0 && absLon > 116.0 && absLon < 117.0 {
            return "北京"
        }

        // Shanghai area
        if absLat > 30.0 && absLat < 32.0 && absLon > 121.0 && absLon < 122.0 {
            return "上海"
        }

        // Default: show coordinates
        return String(format: "位置 %.2f, %.2f", lat, lon)
    }

    /// Helper to add timeout to async operations
    private func withTimeout<T>(seconds: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                throw LocationError.geocodingFailed("Timeout")
            }

            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }

    /// Convert CLLocation to our Location model
    func createLocation(from clLocation: CLLocation, name: String) -> Location {
        return Location(
            name: name,
            latitude: clLocation.coordinate.latitude,
            longitude: clLocation.coordinate.longitude,
            timezone: TimeZone.current.identifier
        )
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus

            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                // Request location immediately after authorization
                requestLocation()
            } else if authorizationStatus == .denied || authorizationStatus == .restricted {
                error = .authorizationDenied
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        Task { @MainActor in
            currentLocation = location

            // Geocode the location
            do {
                let name = try await geocodeLocation(location)
                locationName = name
            } catch {
                self.error = .geocodingFailed(error.localizedDescription)
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            if let clError = error as? CLError {
                switch clError.code {
                case .denied:
                    self.error = .authorizationDenied
                case .network:
                    self.error = .networkError
                default:
                    self.error = .unknown(error.localizedDescription)
                }
            } else {
                self.error = .unknown(error.localizedDescription)
            }
        }
    }
}

/// Location-related errors
enum LocationError: LocalizedError {
    case authorizationDenied
    case geocodingFailed(String)
    case networkError
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return "位置访问被拒绝"
        case .geocodingFailed(let message):
            return "位置解析失败: \(message)"
        case .networkError:
            return "网络错误"
        case .unknown(let message):
            return "未知错误: \(message)"
        }
    }
}
