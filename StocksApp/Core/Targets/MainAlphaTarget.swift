//
//  MainAlphaTarget.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation
import Moya

enum MainAlphaTarget {
    case topLose
}

extension MainAlphaTarget: BaseTarget {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseAlphaURL)!
    }
    
    var task: Moya.Task {
        return .requestParameters(
            parameters: [
                "function": "TOP_GAINERS_LOSERS",
                "apikey": GlobalConstants.apiKey
            ],
            encoding: URLEncoding.default)
    }
}
