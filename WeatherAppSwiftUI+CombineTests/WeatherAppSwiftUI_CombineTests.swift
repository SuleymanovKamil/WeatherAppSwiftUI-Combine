//
//  WeatherAppSwiftUI_CombineTests.swift
//  WeatherAppSwiftUI+CombineTests
//
//  Created by Камиль Сулейманов on 22.12.2021.
//

import XCTest
@testable import WeatherAppSwiftUI_Combine

class WeatherAppSwiftUI_CombineTests: XCTestCase {
    var VM: Store!
    
    override func setUpWithError() throws {
        VM = Store()
    }
    
    override func tearDownWithError() throws {
        VM = nil
    }
    
    func testGettingData() throws {
        var forecast: TodayForecast? = nil
        
        let expectation = XCTestExpectation(description: "Parse JSON from API")
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=42.9764&lon=47.5024&appid=16cf9696c382b9ef7eb3981ea30ed2df")!
    
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
 
            XCTAssertNotNil(data, "No data was downloaded.")
            
            let decoder = JSONDecoder()
            do {
                let APIWeather = try decoder.decode(TodayForecast.self, from: data!)
                forecast = APIWeather
              
            } catch {
                print("Error parsing JSON")
            }
            
            expectation.fulfill()
            
        }
        dataTask.resume()
        wait(for: [expectation], timeout: 2)
        
        XCTAssertNotNil(forecast, "Fail to parse JSON")
    }

}
