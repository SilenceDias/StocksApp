//
//  CompanyFMPModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation

struct CompanyFMPModel: Decodable {
    let symbol: String?
    let price: Double?
    let companyName: String?
    let image: String?
    let exchange: String?
    let name: String?
    let currency: String?
    let stockExchange: String?
    let exchangeShortName: String?
}
