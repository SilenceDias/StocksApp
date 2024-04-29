//
//  StockManager.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation
import Moya

final class StockManager {
    static let shared = StockManager()
    
    private let provider = MoyaProvider<StockTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    public func getStocks(completion: @escaping([StockModel]) -> ()){
        provider.request(.stockSymbols) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) else { return }
                print("SUCCESS: \(json)")
                guard let stocks = try? response.map([StockModel].self) else {
                    break
                }
                completion(stocks)
            case .failure:
                completion([])
            }
        }
    }
    
    public func getDetails(symbol: String, completion: @escaping(CompanyModel) -> ()){
        provider.request(.companyProfile(symbol: symbol)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) else { return }
                print("SUCCESS: \(json)")
                guard let stocks = try? response.map(CompanyModel.self) else {
                    break
                }
                completion(stocks)
            case .failure:
                break
            }
        }
    }
    
}
