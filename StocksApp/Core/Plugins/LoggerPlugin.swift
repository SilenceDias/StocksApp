//
//  LoggerPlugin.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation
import Moya

final class LoggerPlugin: PluginType {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            guard let request = response.request else { return }
            
            let logSuccessMessage = "\n ✅ Request Sent seccesfully \n🚀 Request: \(request)"
            print(logSuccessMessage)
        case .failure(let error):
            let logFailureMessage = "\n❌ Error: \(error.localizedDescription)"
            print(logFailureMessage)
        }
    }
}
