//
//  DetailsViewModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 03.05.2024.
//

import UIKit
import DGCharts

class DetailsViewModel {
    
    var pricesOfYear = [HistoricalDataModel]()
    var pricesOfSixMonth =  [HistoricalDataModel]()
    var pricesOfOneMonth = [HistoricalDataModel]()
    var pricesOfOneWeek =  [HistoricalDataModel]()
    var pricesOfOneDay =  [HistoricalDataModel]()
    
    func getSixMonth() -> [HistoricalDataModel] {
        return pricesOfSixMonth
    }
    
    func getOneMonth() -> [HistoricalDataModel] {
        return pricesOfOneMonth
    }
    
    func getWeek() -> [HistoricalDataModel] {
        return pricesOfOneWeek
    }
    
    func getDay() -> [HistoricalDataModel] {
        return pricesOfOneDay
    }
    
    func getYear() -> [HistoricalDataModel] {
        return pricesOfYear
    }
    
    func loadData(symbol: String, completion: @escaping([HistoricalDataModel]) -> ()){
        var priceChanges = [HistoricalDataModel]()
        let group = DispatchGroup()
        let currentDate = Date()
        let oneYearAgo = currentDate - 31536000
        let sixMonthAgo = currentDate - 15638400
        let oneMonthAgo = currentDate - 2629800
        let oneWeekAgo = currentDate - 604800
        let dayAgo = currentDate - 172800
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedCurrentDate = dateFormatter.string(from: currentDate)
        let formattedOneYearAgo = dateFormatter.string(from: oneYearAgo)
        let formattedSixMonthsAgo = dateFormatter.string(from: sixMonthAgo)
        let formattedOneMonthAgo = dateFormatter.string(from: oneMonthAgo)
        let formattedOneWeekAgo = dateFormatter.string(from: oneWeekAgo)
        let formattedDayAgo = dateFormatter.string(from: dayAgo)
        group.enter()
        FMPManager.shared.getHistoricalPrice(symbol: symbol, timeInterval: "4hour", from: formattedOneYearAgo, to: formattedCurrentDate) { [weak self] prices in
            prices.forEach { price in
                priceChanges.append(.init(prices: price.close, data: price.date))
                self?.pricesOfYear.append(.init(prices: price.close, data: price.date))
            }
            
            group.leave()
        }
        
        group.enter()
        FMPManager.shared.getHistoricalPrice(symbol: symbol, timeInterval: "4hour", from: formattedSixMonthsAgo, to: formattedCurrentDate) { [weak self] prices in
            prices.forEach { price in
                self?.pricesOfSixMonth.append(.init(prices: price.close, data: price.date))
            }
            group.leave()
        }
        
        group.enter()
        FMPManager.shared.getHistoricalPrice(symbol: symbol, timeInterval: "4hour", from: formattedOneMonthAgo, to: formattedCurrentDate) { [weak self] prices in
            prices.forEach { price in
                self?.pricesOfOneMonth.append(.init(prices: price.close, data: price.date))
            }
            group.leave()
        }
        
        group.enter()
        FMPManager.shared.getHistoricalPrice(symbol: symbol, timeInterval: "4hour", from: formattedOneWeekAgo, to: formattedCurrentDate) { [weak self] prices in
            prices.forEach { price in
                self?.pricesOfOneWeek.append(.init(prices: price.close, data: price.date))
            }
            group.leave()
        }
        
        group.enter()
        FMPManager.shared.getHistoricalPrice(symbol: symbol, timeInterval: "4hour", from: formattedDayAgo, to: formattedCurrentDate) { [weak self] prices in
            prices.forEach { price in
                self?.pricesOfOneDay.append(.init(prices: price.close, data: price.date))
            }
            group.leave()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            completion(priceChanges)
        }
    }
}
