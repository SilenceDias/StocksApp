//
//  MainAlphaManager.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation
import Moya

final class MainAlphaManager {
    static let shared = MainAlphaManager()
    
    private let provider = MoyaProvider<MainAlphaTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func getData(completion: @escaping(TopLosersModel) -> ()){
        provider.request(.topLose) { result in
            switch result {
            case .success(let response):
                guard let json = try? JSONSerialization.jsonObject(with: response.data) else { return }
                print("SUCCESS: \(json)")
                guard let stocks = try? response.map(TopLosersModel.self) else {
                    break
                }
                completion(stocks)
            case .failure:
                break
            }
        }
    }
}
