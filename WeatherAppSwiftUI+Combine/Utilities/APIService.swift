//
//  APIService.swift
//  WeatherApp
//
//  Created by Камиль Сулейманов on 13.10.2021.
//

import SwiftUI
import Combine

class APIService: ObservableObject {
    static let shared = APIService()
    
    //MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    let API = "https://api.openweathermap.org/"
    let APIID = "16cf9696c382b9ef7eb3981ea30ed2df"
    let locationManager = LocationManager.shared
    
    //MARK: - Publishers
    @Published var todayForecast: TodayForecast?
    @Published var location = ""
    
    init() {
        subscriptions()
    }
    
    //MARK: - Subscriptions
    
    private func subscriptions() {
        locationManager.$lastLocation
            .sink { [weak self] location in
                guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else {
                    return
                }
                self?.getWeather(lat: latitude, long: longitude)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    func getWeather(lat: Double, long: Double) {
        guard let url = URL(string: API + "data/2.5/weather?lat=\(lat)&lon=\(long)&appid=" + APIID) else {
            return }
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TodayForecast.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink { taskCompletion in
                switch taskCompletion {
                case .finished:
                    return
                case .failure(let decodingError):
                    print("Error: \(decodingError.localizedDescription)")
                }
            } receiveValue: { [weak self] todayForecast in
                guard let self = self else {
                    return
                }
                self.todayForecast = todayForecast
            }
            .store(in: &cancellables)
    }
    
}


