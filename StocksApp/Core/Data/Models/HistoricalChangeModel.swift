//
//  HistoricalChangeModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 02.05.2024.
//

import Foundation

struct HistoricalChangeModel: Decodable {
    let date: String
    let open: Double
    let low: Double
    let high: Double
    let close: Double
}
