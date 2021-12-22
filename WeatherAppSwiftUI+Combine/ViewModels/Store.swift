//
//  Store.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 21.12.2021.
//

import SwiftUI
import Combine

class Store: ObservableObject {
    
    //MARK: - Properties
    
    let locationManager = LocationManager.shared
    let apiService = APIService.shared
    let coreData = CoreDataService.shared
    var cancellables = Set<AnyCancellable>()
    var currentTemp: String {
        if let temp = convert(todayForecast?.main.temp) {
            return String(format: "%.0f", temp)
        } else {
            return ""
        }
    }
    var backgroundColor: Color {
        if let temp = convert(todayForecast?.main.temp) {
            switch temp   {
            case -200..<(isCelsius ? 10 : 50):
                return .blue.opacity(0.3)
            case (isCelsius ? 10 : 50)..<(isCelsius ? 25 : 77):
                return .orange
            case (isCelsius ? 25 : 77)...200:
                return.red
            default:
                return .clear
            }
        } else {
            return .clear
        }
    }

    //MARK: - Publishers
    
    @Published var location = ""
    @AppStorage("isCelsius") var isCelsius = true
    @Published var todayForecast: TodayForecast?
    @Published var showChart = false
    @Published var startSearch = false
    
    init() {
        subscription()
    }
    
    //MARK: - Subscription
    
    private func subscription() {
        apiService.$todayForecast
            .dropFirst()
            .sink { [weak self] todayForecast in
                guard let self = self else {
                    return
                }
                self.todayForecast = todayForecast
                
                let searchHistory = SearchHistory(context: self.coreData.container.viewContext)
                searchHistory.city = todayForecast?.name
                searchHistory.date = Date().toString(date: .short)
                searchHistory.temperature = todayForecast?.main.temp ?? 0
                if !self.coreData.searchHistory.contains(searchHistory) {
                    self.coreData.saveSearchHistory()
                }
                self.startSearch = false
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
     func getLocation() {
        startSearch = true
        locationManager.getLocation()
    }
    
    func convert(_ temp: Double?) -> Double? {
        guard let temp = temp else {
            return nil
        }
        let celsius = temp - 273.5
        if isCelsius  {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
    }
    
}
