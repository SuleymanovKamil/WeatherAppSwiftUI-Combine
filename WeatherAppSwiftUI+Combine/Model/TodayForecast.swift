//
//  TodayForecast.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 22.12.2021.
//

import Foundation

struct TodayForecast: Codable {
    let main: Main
    let name: String
    struct Main: Codable {
        let temp: Double
    }
}
