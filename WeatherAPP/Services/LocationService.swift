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

    /// Geocode location to get city name
    func geocodeLocation(_ location: CLLocation) async throws -> String {
        // Use CLGeocoder for reverse geocoding
        // Note: While deprecated in iOS 26.0, it's more reliable than MKLocalSearch for this purpose
        // The new MKReverseGeocodingRequest API is not yet widely documented
        return try await withCheckedThrowingContinuation { continuation in
            #if compiler(>=6.0)
            #warning("TODO: Migrate to MKReverseGeocodingRequest when available and documented")
            #endif
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    // Fallback to coordinate-based name
                    let lat = String(format: "%.2f", location.coordinate.latitude)
                    let lon = String(format: "%.2f", location.coordinate.longitude)
                    continuation.resume(returning: "位置 \(lat), \(lon)")
                    return
                }

                if let placemark = placemarks?.first {
                    let locality = placemark.locality ?? placemark.subLocality
                    let name = locality ?? placemark.administrativeArea ?? placemark.name ?? "未知位置"
                    continuation.resume(returning: name)
                } else {
                    continuation.resume(returning: "未知位置")
                }
            }
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
