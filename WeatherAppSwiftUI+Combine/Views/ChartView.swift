//
//  ChartView.swift
//  WeatherAppSwiftUI+Combine
//
//  Created by Камиль Сулейманов on 22.12.2021.
//

import SwiftUI

struct ChartView: View {
    @EnvironmentObject private var store: Store
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: SearchHistory.entity(), sortDescriptors: [])
    private var searchHistory: FetchedResults<SearchHistory>
    
    var body: some View {
        VStack {
            chartView
            chartDateLabels
            searchHistoryListTitle
            searchHistoryList
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .environmentObject(Store())
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            let temps = searchHistory.map{store.convert($0.temperature)?.rounded() ?? 0}.sorted()
            Path { path in
                for index in temps.indices {
                    let xPosition = geometry.size.width / CGFloat(temps.count) * CGFloat(index + 1)
                    
                    let yAxis = (temps.last ?? 0) - (temps.first ?? 0)
                    
                    let yPosition = (1 - CGFloat((temps[index] - (temps.first ?? 0)) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: (temps.last ?? 1))
            .stroke(.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .frame(height: 300)
        .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
    }
    
    private var chartYAxis: some View {
        VStack {
            let temps = searchHistory.map{store.convert($0.temperature)?.rounded() ?? 0}.sorted()
            Text((temps.last ?? 0).string + "°")
            Spacer()
            Text((temps.first ?? 0).string + "°")
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(searchHistory.first?.date ?? "")
            Spacer()
            Text(searchHistory.last?.date ?? "")
        }
    }
    
    private var searchHistoryListTitle: some View {
        Text("Weather requests history")
            .font(.headline)
            .padding(.top)
    }
    
    private var searchHistoryList: some View {
        List(searchHistory.sorted{ $0.temperature < $1.temperature }, id: \.self) { request in
            HStack {
                VStack (alignment: .leading){
                    HStack {
                        Text(request.city ?? "" + ", ")
                        Text(String(format: "%.0f", store.convert(request.temperature) ?? 0.0) + "°")
                    }
                    Text(request.date ?? "")
                }
            }
        }
        .listStyle(.plain)
    }
}
