//
//  StockData.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//


struct Stock: Decodable {
    let currency: String
    let symbol: String
    let stockExchange: String
    let name: String
}
