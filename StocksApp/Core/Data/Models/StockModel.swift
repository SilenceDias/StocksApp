//
//  StockModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation

struct StockModel: Decodable {
    let currency: String
    let description: String
    let displaySymbol: String
    let figi: String?
    let mic: String?
    let symbol: String
    let type: String
}
