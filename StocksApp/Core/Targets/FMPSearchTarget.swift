//
//  FMPSearchTarget.swift
//  StocksApp
//
//  Created by Aneli  on 30.04.2024.
//

import Foundation
import Moya

enum FMPSearchTarget {
    case search(query: String, limit: Int?, exchange: String?)
}

extension FMPSearchTarget: TargetType {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseFMPURL)!
    }
    
    var path: String {
        return "/search"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .search(let query, let limit, let exchange):
            var parameters: [String: Any] = [
                "query": query,
                "apikey": GlobalConstants.apiKeyFMP
            ]
            
            if let limit = limit {
                parameters["limit"] = limit
            }
            
            if let exchange = exchange {
                parameters["exchange"] = exchange
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}

