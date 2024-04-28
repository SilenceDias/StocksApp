//
//  StockTarget.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import Foundation
import Moya

enum StockTarget: BaseTarget {
    case symbolLookup(query: String)
    
    var path: String {
        switch self {
        case .symbolLookup:
            return "/search"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .symbolLookup:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .symbolLookup(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "X-Finnhub-Token": GlobalConstants.apiKey]
    }
}
