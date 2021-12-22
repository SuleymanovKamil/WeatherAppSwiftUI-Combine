//
//  LocationManager.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 21.12.2021.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    //MARK: - Publishers
    
    @Published var lastLocation: CLLocation?
    
    //MARK: - Methods
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
        guard let location = locations.last else { return }
        lastLocation = location
        locationManager.stopUpdatingLocation()
    }
    
    func getSearchLocation(_ location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            guard let placemarks = placemarks else {
                return
            }
            if let lat = placemarks.first?.location?.coordinate.latitude,
               let lon = placemarks.first?.location?.coordinate.longitude {
                APIService.shared.getWeather(lat: lat, long: lon)
            }
        }
    }
    
}

