//
//  NetworkLoggerPluginConfig.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation
import Moya

enum NetworkLoggerPluginConfig {
    static let prettyLogging = NetworkLoggerPlugin.Configuration(
        formatter: NetworkLoggerPlugin.Configuration.Formatter(
            requestData: JSONDataToStringFormatter,
            responseData: JSONDataToStringFormatter
        ),
        output: safeOutput,
        logOptions: .verbose
    )
    
    private static func JSONDataToStringFormatter(_ data: Data) -> String {
        do {
            let dataAsJson = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJson, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? ""
        }
        catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    private static func safeOutput(target: TargetType, items: [String]){
        for item in items {
            print(item, separator: ",", terminator: "\n")
        }
    }
}
