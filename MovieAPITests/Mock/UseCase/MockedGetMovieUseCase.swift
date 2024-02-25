//
//  MockedGetMovieUseCase.swift
//  MovieAPITests
//
//  Created by Bangkit on 26/02/24.
//

import Foundation
import Mockit
import XCTest
import Promises
@testable import MovieAPI

final class MockedGetMovieUseCase: GetMovieUseCase, Mock {
    typealias InstanceType = MockedGetMovieUseCase
    let callHandler: CallHandler
    
    func instanceType() -> MockedGetMovieUseCase {
        return self
    }
    
    init(testCase: XCTestCase) {
        self.callHandler = CallHandlerImpl(withTestCase: testCase)
    }
    
    func execute(title: String) -> Promise<Movie> {
        return (callHandler
            .accept(nil,
                    ofFunction: #function,
                    atFile: #file,
                    inLine: #line,
                    withArgs: title) as? Promise<Movie>
        ) ?? (Promise<Movie>(NSError(domain: "Bad Request", code: 404)))
    }
}
