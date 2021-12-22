
//  WeatherAppSwiftUI_CombineApp.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 21.12.2021.
//

import SwiftUI
import CoreData

class CoreDataService: ObservableObject{
    static let shared = CoreDataService()
    
    //MARK: - Properties
    
    let container: NSPersistentContainer
    @Published var searchHistory: [SearchHistory] = []
    
    private init() {
        container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Error loading CoreData. \(error)")
            }
        }
        fetchSearhHistory()
    }
    
    //MARK: - Methods
    
    private func fetchSearhHistory() {
        let request = NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
        
        do {
            searchHistory = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching data. \(error)")
        }
    }
   
    func saveSearchHistory() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
     func deleteSearchHistory(_ searchHistory: SearchHistory) {
        container.viewContext.delete(searchHistory)
        do {
            try container.viewContext.save()
        
        } catch let error {
            print("Error saving coredata. \(error)")
        }
    }
    
}



