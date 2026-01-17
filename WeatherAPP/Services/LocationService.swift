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

    /// Geocode location to get city name using MapKit
    func geocodeLocation(_ location: CLLocation) async throws -> String {
        // Use MapKit's MKLocalSearch for reverse geocoding (iOS 26.0+ compliant)
        let searchRequest = MKLocalSearch.Request()

        // Create a small region around the coordinate
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )
        searchRequest.region = region
        searchRequest.resultTypes = .address

        let search = MKLocalSearch(request: searchRequest)

        do {
            let response = try await search.start()

            // Try to get location name from mapItems
            if let mapItem = response.mapItems.first {
                // Use the name directly from mapItem (non-deprecated)
                if let name = mapItem.name, !name.isEmpty {
                    // MKMapItem.name is not deprecated and provides location info
                    return name
                }

                // If name is empty, try using timeZone + coordinates
                if let timeZone = mapItem.timeZone {
                    // Use timezone identifier to guess location
                    let components = timeZone.identifier.components(separatedBy: "/")
                    if components.count > 1 {
                        return components.last ?? "未知位置"
                    }
                }
            }

            // If no results, return coordinate-based name
            let lat = String(format: "%.2f", location.coordinate.latitude)
            let lon = String(format: "%.2f", location.coordinate.longitude)
            return "位置 \(lat), \(lon)"

        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            // Fallback to coordinate-based name
            let lat = String(format: "%.2f", location.coordinate.latitude)
            let lon = String(format: "%.2f", location.coordinate.longitude)
            return "位置 \(lat), \(lon)"
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
