//
//  MovieDataSourceSpec.swift
//  MovieAPITests
//
//  Created by Bangkit on 31/01/24.
//

import XCTest
import Promises
import Mockit
import Nimble
import Alamofire
@testable import Promises
@testable import MovieAPI

final class MovieDataSourceSpec: XCTestCase {
    var sut: MovieDataSource!
    var mockedAPIManager: MockedAPIManager!
    
    override func setUp() {
        mockedAPIManager = MockedAPIManager(testCase: self)
        sut = MovieDataSourceImpl(apiManager: mockedAPIManager)
    }
    
    override func tearDown() {
        mockedAPIManager = nil
        sut = nil
    }
    
    func test_getMovie_should_be_called() {
        let result: (Result<[String: Any]?>) -> () = { response in
            switch response {
            case .success(let data):
                _ = data ?? [:]
            case .failure(let error):
                _ = error
            }
        }
        
        sut.getMovie(title: "", result: result)
        
        mockedAPIManager.verify(verificationMode: Once())
            .callApi(url: "", method: .get, parameters: nil, encoding: URLEncoding.default, result: result)
    }
    
    func test_getMovieList_should_be_called() {
        let result: (Result<[String: Any]?>) -> () = { response in
            switch response {
            case .success(let data):
                _ = data ?? [:]
            case .failure(let error):
                _ = error
            }
        }
        
        sut.getMovieList(search: "", page: 0, result: result)
        
        mockedAPIManager.verify(verificationMode: Once())
            .callApi(url: "", method: .get, parameters: nil, encoding: URLEncoding.default, result: result)
    }
}
