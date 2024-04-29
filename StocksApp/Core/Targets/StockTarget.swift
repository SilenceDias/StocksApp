//
//  StockTarget.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation
import Moya

enum StockTarget {
    case stockSymbols
    case companyProfile(symbol: String)
}

extension StockTarget: BaseTarget {
    var path: String {
        switch self {
        case .stockSymbols:
            return "/stock/symbol"
        case .companyProfile:
            return "/stock/profile2"
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .stockSymbols:
            return .requestParameters(
                parameters: [
                    "exchange": "US",
                    "token": GlobalConstants.apiKey
                ],
                encoding: URLEncoding.default)
        case .companyProfile(let symbol):
            return .requestParameters(
                parameters: [
                    "symbol": symbol,
                    "token": GlobalConstants.apiKey
                ],
                encoding: URLEncoding.default)
        }
    }
}
