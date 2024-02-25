//
//  MockedMovieDataSource.swift
//  MovieAPITests
//
//  Created by Bangkit on 30/01/24.
//

import Foundation
import Mockit
import XCTest
import Promises
@testable import MovieAPI

final class MockedMovieDataSource: MovieDataSource, Mock {
    typealias InstanceType = MockedMovieDataSource
    let callHandler: CallHandler
    
    func instanceType() -> MockedMovieDataSource {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    func getMovie(title: String, result: @escaping (Result<[String : Any]?>) -> ()) {
        callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: title, result)
    }
    
    func getMovieList(search: String, page: Int, result: @escaping (Result<[String : Any]?>) -> ()) {
        callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: search, page, result)
    }
}
