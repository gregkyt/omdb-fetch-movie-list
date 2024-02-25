//
//  MockedMovieRepository.swift
//  MovieAPITests
//
//  Created by Bangkit on 30/01/24.
//

import Foundation
import Mockit
import XCTest
import Promises
@testable import MovieAPI

final class MockedMovieRepository: MovieRepository, Mock {
    typealias InstanceType = MockedMovieRepository
    let callHandler: CallHandler
    
    func instanceType() -> MockedMovieRepository {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    func getMovie(title: String) -> Promise<Movie> {
        return (callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: title) as? Promise<Movie>
        ) ?? (Promise<Movie>(NSError(domain: "Bad Request", code: 404)))
    }
    
    func getMovieList(search: String, page: Int) -> Promise<[Movie]> {
        return (callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: search, page) as? Promise<[Movie]>
        ) ?? (Promise<[Movie]>(NSError(domain: "Bad Request", code: 404)))
    }
}
