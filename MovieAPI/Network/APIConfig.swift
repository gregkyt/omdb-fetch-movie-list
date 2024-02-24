//
//  APIConfig.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation

struct APIConfig {
    static let baseUrl = "https://www.omdbapi.com"
    static let title = "t"
    static let apiKey = "7584f6b8"
}

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

enum Result<T> {
    case success(T)
    case failure(APIError)
}
