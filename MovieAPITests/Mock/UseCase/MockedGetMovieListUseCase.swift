//
//  MockedGetMovieListUseCase.swift
//  MovieAPITests
//
//  Created by Bangkit on 26/02/24.
//

import Foundation
import Mockit
import XCTest
import Promises
@testable import MovieAPI

final class MockedGetMovieListUseCase: GetMovieListUseCase, Mock {
    typealias InstanceType = MockedGetMovieListUseCase
    let callHandler: CallHandler
    
    func instanceType() -> MockedGetMovieListUseCase {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    func execute(search: String, page: Int) -> Promise<[Movie]> {
        return (callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: search, page) as? Promise<[Movie]>
        ) ?? (Promise<[Movie]>(NSError(domain: "Bad Request", code: 404)))
    }
}
