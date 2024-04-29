//
//  SearchViewModel.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import Foundation

class SearchViewModel {
    private let stockSearchManager = StockSearchManager.shared
    private var searchResults: [Stock] = []
    
    func search(query: String, completion: @escaping ([Stock]) -> Void) {
        let target = StockTarget.symbolLookup(query: query)
        stockSearchManager.perform(target) { (result: Result<[Stock], APINetworkError>) in
            switch result {
            case .success(let stocks):
                self.searchResults = stocks
                completion(stocks)
            case .failure(let error):
                completion([])
            }
        }
    }
}
