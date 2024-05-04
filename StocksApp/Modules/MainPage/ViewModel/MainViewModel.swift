//
//  MainViewModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import UIKit

class MainViewModel {
    
    let dispatchGroup = DispatchGroup()
    
    private lazy var stocks = [
        StocksGroup(title: "Popular", stocks: []),
        StocksGroup(title: "Top Gainers", stocks: []),
        StocksGroup(title: "Top Losers", stocks: [])
    ]
    
    
    var numberOfSections: Int {
        return stocks.count
    }
    
    func getNumberInSection(section: Int) -> Int {
        return stocks[section].stocks.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksDataModel {
        return stocks[indexPath.section].stocks[indexPath.row]
    }
    
    func getHeaderTitle(section: Int) -> String {
        return stocks[section].title
    }
    
    
    
    func loadData(comletion: @escaping () -> ()){
        dispatchGroup.enter()
        MainAlphaManager.shared.getData { [weak self] result in
            result.mostActivelyTraded.forEach { ticket in
                var stock = StocksDataModel(symbol: ticket.ticker, name: ticket.ticker, symbolId: ticket.ticker, imageUrl: "", price: ticket.price, priceChange: ticket.changeAmount, changePercentage: ticket.changePercentage)
                self?.stocks[0].stocks.append(stock)
            }
            
            result.topGainers.forEach { ticket in
                var stock = StocksDataModel(symbol: ticket.ticker, name: ticket.ticker, symbolId: ticket.ticker, imageUrl: "", price: ticket.price, priceChange: ticket.changeAmount, changePercentage: ticket.changePercentage)
                self?.stocks[1].stocks.append(stock)
            }
            
            result.topLosers.forEach { ticket in
                var stock = StocksDataModel(symbol: ticket.ticker, name: ticket.ticker, symbolId: ticket.ticker, imageUrl: "", price: ticket.price, priceChange: ticket.changeAmount, changePercentage: ticket.changePercentage)
                self?.stocks[2].stocks.append(stock)
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            for i in 0..<(self?.stocks.count ?? 1) {
                for j in 0..<(self?.stocks[i].stocks.count ?? 1){
                    FMPManager.shared.getCompanyProfile(symbol: self?.stocks[i].stocks[j].symbol ?? "") { result in
                        self?.stocks[i].stocks[j].imageUrl = result.first?.image ?? ""
                        self?.stocks[i].stocks[j].name = result.first?.companyName ?? ""
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                comletion()
            }
        }
    }
}
