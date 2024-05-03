//
//  FMPManager.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation
import Moya

final class FMPManager {
    static let shared = FMPManager()
    
    private let provider = MoyaProvider<FMPCompanyTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getCompanyProfile(symbol: String, completion: @escaping([CompanyFMPModel]) -> ()){
        provider.request(.getCompanyProfile(symbol: symbol)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) else { return }
                print("SUCCESS: \(json)")
                guard let stocks = try? response.map([CompanyFMPModel].self) else {
                    break
                }
                completion(stocks)
            case .failure:
                break
            }
        }
    }
    
    func getHistoricalPrice(symbol: String, timeInterval: String, from: String, to: String, completion: @escaping ([HistoricalChangeModel]) -> ()){
        provider.request(.getHistoricalPrice(symbol: symbol, timeInterval: timeInterval, from: from, to: to)) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) else { return }
                print("SUCCESS: \(json)")
                guard let stocks = try? response.map([HistoricalChangeModel].self) else {
                    break
                }
                completion(stocks)
            case .failure:
                break
            }
        }
    }
}
