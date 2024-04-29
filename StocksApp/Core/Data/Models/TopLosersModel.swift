//
//  TopLosersModel.swift
//  StocksApp
//
//  Created by Диас Мухамедрахимов on 29.04.2024.
//

import Foundation

struct TopLosersModel: Decodable {
    let topGainers: [Ticket]
    let topLosers: [Ticket]
    let mostActivelyTraded: [Ticket]
    
    enum CodingKeys: String, CodingKey {
        case topGainers = "top_gainers"
        case topLosers = "top_losers"
        case mostActivelyTraded = "most_actively_traded"
    }
}

struct Ticket: Decodable {
    let ticker: String
    let price: String
    let changeAmount: String
    let changePercentage: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case price
        case changeAmount = "change_amount"
        case changePercentage = "change_percentage"
        case volume
    }
}
