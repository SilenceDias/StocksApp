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
}

extension FMPCompanyTarget: BaseTarget {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseFMPURL)!
    }
    
    var path: String {
        switch self {
        case .getCompanyProfile(let symbol):
            return "/profile/\(symbol)"
        }
    }
    
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "apikey": GlobalConstants.apiKeyFMP
            ],
            encoding: URLEncoding.default)
    }
}
