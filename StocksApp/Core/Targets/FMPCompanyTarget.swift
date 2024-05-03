//
//  FMPCompanyTarget.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation
import Moya

enum FMPCompanyTarget {
    case getCompanyProfile(symbol: String)
    case getHistoricalPrice(symbol: String, timeInterval: String, from: String, to: String)
}

extension FMPCompanyTarget: BaseTarget {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseFMPURL)!
    }
    
    var path: String {
        switch self {
        case .getCompanyProfile(let symbol):
            return "/profile/\(symbol)"
        case .getHistoricalPrice(let symbol, let timeInterval, let from, let to):
            return "/historical-chart/\(timeInterval)/\(symbol)"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCompanyProfile:
            return .requestParameters(
                parameters: [
                    "apikey": GlobalConstants.apiKeyFMP
                ],
                encoding: URLEncoding.default)
        case .getHistoricalPrice(let symbol, let timeInterval, let from, let to):
            return .requestParameters(
                parameters: [
                    "from": from,
                    "to": to,
                    "apikey": GlobalConstants.apiKeyFMP
                ],
                encoding: URLEncoding.default)
        }
    }
}
