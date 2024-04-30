//
//  FMPSearchManager.swift
//  StocksApp
//
//  Created by Aneli  on 30.04.2024.
//

import Foundation
import Moya

final class FMPSearchManager {
    static let shared = FMPSearchManager()
    
    private let provider = MoyaProvider<FMPSearchTarget>(
        plugins: [
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging),
            LoggerPlugin()
        ]
    )
    
    func searchCompanies(query: String, completion: @escaping(Result<[CompanyFMPModel], Error>) -> Void) {
        provider.request(.search(query: query, limit: 15, exchange: nil)) { result in
            switch result {
            case .success(let response):
                do {
                    let companies = try response.map([CompanyFMPModel].self)
                    completion(.success(companies))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
