//
//  SearchViewModel.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

//import Foundation
//
//class SearchViewModel {
//    private let stockSearchManager = StockSearchManager.shared
//    private var searchResults: [Stock] = []
//    
//    func search(query: String, completion: @escaping ([Stock]) -> Void) {
//        let target = StockTarget.symbolLookup(query: query)
//        stockSearchManager.perform(target) { (result: Result<[Stock], APINetworkError>) in
//            switch result {
//            case .success(let stocks):
//                self.searchResults = stocks
//                completion(stocks)
//            case .failure(let error):
//                completion([])
//            }
//        }
//    }
//}

import Foundation

class SearchViewModel {
    
    let dispatchGroup = DispatchGroup()
    
    private lazy var searchResults = [
        StocksGroup(title: "Search Results", stocks: [])
    ]
    
    func search(query: String, completion: @escaping () -> Void) {
        dispatchGroup.enter()
        FMPSearchManager.shared.searchCompanies(query: query) { [weak self] result in
            switch result {
            case .success(let companies):
                let stocksDataModels = companies.map { company -> StocksDataModel in
                    return StocksDataModel(symbol: company.symbol ?? "", name: company.name ?? "", symbolId: "", imageUrl: company.image ?? "", price: "", priceChange: "", changePercentage: "")
                }
                self?.searchResults[0].stocks = stocksDataModels
                self?.dispatchGroup.leave()
            case .failure(let error):
                print("Ошибка при поиске компаний: \(error)")
                self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getNumberInSection(section: Int) -> Int {
        return searchResults[section].stocks.count
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksDataModel {
        return searchResults[indexPath.section].stocks[indexPath.row]
    }
    
    func getHeaderTitle(section: Int) -> String {
        return searchResults[section].title
    }
}
