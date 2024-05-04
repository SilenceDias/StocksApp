//
//  StockTarget.swift
//  StocksApp
//
//  Created by Aneli  on 30.04.2024.
//

import Foundation
import Moya

enum StockTarget {
    case stockSymbols
    case companyProfile(symbol: String)
    case symbolLookup(query: String)
}

extension StockTarget: BaseTarget {
    var path: String {
        switch self {
        case .stockSymbols:
            return "/stock/symbol"
        case .companyProfile:
            return "/stock/profile2"
         case .symbolLookup:
            return "/search"
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
        case .symbolLookup(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "X-Finnhub-Token": GlobalConstants.apiKey]
    }
}
