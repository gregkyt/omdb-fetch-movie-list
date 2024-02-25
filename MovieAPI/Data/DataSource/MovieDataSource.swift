//
//  MovieDataSource.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Alamofire

protocol MovieDataSource {
    func getMovie(title: String, result: @escaping (Result<[String: Any]?>) -> ())
    func getMovieList(search: String, page: Int, result: @escaping (Result<[String: Any]?>) -> ())
}

struct MovieDataSourceImpl: MovieDataSource {
    typealias MovieInstance = (APIManager) -> MovieDataSourceImpl
    
    fileprivate let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    static let shared: MovieInstance = { api in
        return MovieDataSourceImpl(apiManager: api)
    }
    
    func getMovie(title: String, result: @escaping (Result<[String : Any]?>) -> ()) {
        apiManager.callApi(
            url: APIConfig.baseUrl + "?apiKey=\(APIConfig.apiKey)&t=\(title)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default) { response in
                result(response)
            }
    }
    
    func getMovieList(search: String, page: Int, result: @escaping (Result<[String : Any]?>) -> ()) {
        apiManager.callApi(
            url: APIConfig.baseUrl + "?apiKey=\(APIConfig.apiKey)&s=\(search)&page=\(page)",
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default) { response in
                result(response)
            }
    }
}
