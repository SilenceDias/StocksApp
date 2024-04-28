//
//  StockData.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

struct Profile: Decodable {
    let name: String
}

struct Ticker: Decodable {
    let displaySymbol: String
}

struct Stock: Decodable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
    let profile: Profile
    let ticker: Ticker
}
