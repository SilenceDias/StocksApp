//
//  SearchViewModel.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import Foundation

class SearchViewModel {
    
    let dispatchGroup = DispatchGroup()
    
    private lazy var searchResults = [
        StocksGroup(title: "Search Results", stocks: [])
    ]
    
    func search(query: String, completion: @escaping ([StocksDataModel]) -> Void) {
        dispatchGroup.enter()
        FMPSearchManager.shared.searchCompanies(query: query) { [weak self] result in
            switch result {
            case .success(let companies):
                let stocksDataModels = companies.map { company -> StocksDataModel in
                    return StocksDataModel(symbol: company.symbol, name: company.name, symbolId: "", imageUrl: "", price: "", priceChange: "", changePercentage: "")
                }
                self?.searchResults[0].stocks = stocksDataModels
                self?.dispatchGroup.leave()
            case .failure(let error):
                print("Ошибка при поиске компаний: \(error)")
                self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            for i in 0..<(self.searchResults[0].stocks.count) {
                FMPManager.shared.getCompanyProfile(symbol: self.searchResults[0].stocks[i].symbol) { result in
                    self.searchResults[0].stocks[i].imageUrl = result.first?.image ?? ""
                    self.searchResults[0].stocks[i].name = result.first?.companyName ?? ""
                    self.searchResults[0].stocks[i].price = String(result.first?.price ?? 0)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                completion(self.searchResults[0].stocks)
            }
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksDataModel {
        return searchResults[0].stocks[indexPath.row]
    }
    func getNumberOfItems() -> Int {
        return searchResults[0].stocks.count
    }
    
    func getSearchResults() -> [StocksDataModel] {
        return searchResults[0].stocks
    }
}
