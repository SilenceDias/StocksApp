//
//  StockManager.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import Foundation
import Moya

protocol StockManagerProtocol {
    func perform<T: Decodable>(_ target: StockTarget, completion: @escaping (Result<T, APINetworkError>) -> Void)
}

final class StockSearchManager: StockManagerProtocol {
    static let shared = StockSearchManager()
    
    private let provider = MoyaProvider<StockTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func perform<T: Decodable>(_ target: StockTarget, completion: @escaping (Result<T, APINetworkError>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(T.self)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                switch error {
                case .underlying(let nsError as NSError, _):
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        completion(.failure(.noInternetConnection))
                    } else {
                        completion(.failure(.unknownError))
                    }
                default:
                    completion(.failure(.unknownError))
                }
            }
        }
    }
}
