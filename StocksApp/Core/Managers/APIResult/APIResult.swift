//
//  APIResult.swift
//  StocksApp
//
//  Created by Aneli  on 27.04.2024.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(APINetworkError)
}

enum APINetworkError: Error {
    case failedGET
    case invalidURL
    case dataNotFound
    case httpRequestFailed
    case decodingError
    case noInternetConnection
    case unknownError
}

extension APINetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedGET:
            return "Error: Failed to perform GET request"
        case .invalidURL:
            return "Error: Invalid URL"
        case .dataNotFound:
            return "Error: Data not found"
        case .httpRequestFailed:
            return "Error: HTTP request failed"
        case .decodingError:
            return "Error: Failed to decode data"
        case .noInternetConnection:
            return "Error: No internet connection"
        case .unknownError:
            return "Error: Unknown error occurred"
        }
    }
}

enum StockManagerError: Error {
    case networkError(APINetworkError)
    case invalidJSON
    case unknown
    case customError(String)
}

extension StockManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let apiError):
            return apiError.errorDescription
        case .invalidJSON:
            return "Error: Incorrect JSON format"
        case .unknown:
            return "Error: Unknown error occurred"
        case .customError(let message):
            return message
        }
    }
}
