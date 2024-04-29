//
//  SrocksDataModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 26.04.2024.
//

import Foundation

struct StocksGroup {
    let title: String
    var stocks: [StocksDataModel]
}

struct StocksDataModel {
    var symbol: String
    var name: String
    var symbolId: String
    var imageUrl: String
    var price: String
    var priceChange: String
    var changePercentage: String
}
