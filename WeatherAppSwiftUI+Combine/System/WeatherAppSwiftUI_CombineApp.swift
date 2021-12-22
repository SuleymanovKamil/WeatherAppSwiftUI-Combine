//
//  WeatherAppSwiftUI_CombineApp.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 21.12.2021.
//

import SwiftUI

@main
struct WeatherAppSwiftUI_CombineApp: App {
    let persistenceController = CoreDataService.shared
    @StateObject private var store = Store()
    var body: some Scene {
        WindowGroup {
            CurrentWeatherView()
                .environmentObject(store)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
