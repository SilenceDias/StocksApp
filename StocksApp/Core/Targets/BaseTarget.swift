//
//  BaseTarget.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation
import Moya

protocol BaseTarget : TargetType {}

extension BaseTarget {
    var baseURL: URL {
        return URL(string: GlobalConstants.baseURL)!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var task: Moya.Task {
        return .requestPlain
    }

}
