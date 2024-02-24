//
//  APIManager.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Promises
import ObjectMapper
import Alamofire

protocol APIManager {
    func callApi(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding?,
        result: @escaping (Result<[String: Any]?>) -> ()
    )
}

struct APIManagerImpl: APIManager {
    func callApi(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding?,
        result: @escaping (Result<[String: Any]?>) -> ()
    ) {
        var newEncoding: ParameterEncoding? = URLEncoding.default
        var newParam: Parameters? = nil
        if parameters != nil {
            newParam = parameters
        }
        
        if encoding != nil {
            newEncoding = encoding
        }
        
        let request = AF.request(url, method: method, parameters: newParam, encoding: newEncoding!)
        
        request.responseData { response in
            switch (response.result) {
            case .success(let data) :
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                    result(.success(json))
                } catch {
                    result(.failure(APIError.jsonConversionFailure))
                }
            case .failure(_):
                result(.failure(APIError.requestFailed))
            }
        }
    }
}
