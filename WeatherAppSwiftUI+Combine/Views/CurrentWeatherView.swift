//
//  CurrentWeatherView.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 21.12.2021.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject private var store: Store
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: SearchHistory.entity(), sortDescriptors: [])
    private var searchHistory: FetchedResults<SearchHistory>
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 10) {
                searchBar
                weather
                searchHistoryList
            }
            .onTapGesture(perform: UIApplication.shared.endEditing)
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navBarItems
                }
            }
        }
    }
    
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(Store())
    }
}

extension CurrentWeatherView {
    private var searchBar: some View {
        HStack {
            if store.startSearch {
                ProgressView()
                    .padding(.leading, 10)
                    .scaleEffect(0.9)
            } else {
                Button(action: {
                    store.startSearch = true
                    store.locationManager.getSearchLocation(store.location)
                    UIApplication.shared.endEditing()
                    store.location = ""
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(store.location.isEmpty ? .secondary : .accentColor)
                        .font(.callout)
                        .padding(.leading, 10)
                })
            }
            
            TextField("City name", text: $store.location,
                      onCommit: {
                store.startSearch = true
                store.locationManager.getSearchLocation(store.location)
                UIApplication.shared.endEditing()
                store.location = ""
            })
                .overlay (
                    Button(action: {
                        store.location = ""
                    }) {
                        if !store.location.isEmpty {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal),
                    alignment: .trailing
                )
        }
        .padding(.vertical, 5)
        .background(Color.primary.opacity(0.05).cornerRadius(10))
        .padding(.horizontal)
    }
    
    private var weather: some View {
        Group {
            if store.todayForecast != nil {
                VStack (alignment: .leading, spacing: 20) {
                    Text(store.todayForecast?.name ?? "")
                        .font(.largeTitle)
                    
                    HStack {
                        Text(store.currentTemp + "°")
                            .font(.title)
                        
                        Spacer()
                        
                        temperatureScaleToggle
                            .frame(width: 200, alignment: .bottomTrailing)
                    }
                }
                .padding()
                .background(store.backgroundColor)
            }
        }
    }
    
    private var temperatureScaleToggle: some View {
        HStack(spacing: 0) {
            Text("F")
                .bold()
            
            Toggle("", isOn: $store.isCelsius)
                .padding(.horizontal)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.913, green: 0.913, blue: 0.92)))
            
            Text("C")
                .bold()
        }
    }
    
    private var searchHistoryList: some View {
        List(searchHistory, id: \.self) { request in
            HStack {
                VStack (alignment: .leading){
                    HStack {
                        Text(request.city ?? "" + ", ")
                        Text(String(format: "%.0f", store.convert(request.temperature) ?? 0.0) + "°")
                    }
                    Text(request.date ?? "")
                }
                Spacer()
                
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.accentColor)
                    .padding(.trailing)
            }
        }
        .listStyle(.plain)
    }

    private var navBarItems: some View {
        HStack {
            NavigationLink(isActive: $store.showChart) { ChartView() }
        label: {
            Image(systemName: "chart.xyaxis.line")
                .font(.callout)
        }
            Button {
                store.getLocation()
            } label: {
                Image(systemName: "location.north.circle")
                    .font(.callout)
            }
        }
    }
}
