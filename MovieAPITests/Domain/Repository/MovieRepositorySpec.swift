//
//  MovieRepositorySpec.swift
//  MovieAPITests
//
//  Created by Bangkit on 30/01/24.
//

import XCTest
import Promises
import Mockit
import Nimble
@testable import Promises
@testable import MovieAPI

final class MovieRepositorySpec: XCTestCase {
    var sut: MovieRepository!
    var mockedDataSource: MockedMovieDataSource!
    var isRemoteCalled: Bool = false
    
    override func setUp() {
        mockedDataSource = MockedMovieDataSource(testCase: self)
        sut = MovieRepositoryImpl(remote: mockedDataSource)
    }
    
    override func tearDown() {
        mockedDataSource = nil
        sut = nil
        isRemoteCalled = false
    }
    
    func test_getMovie_should_be_called() {
        let result: (Result<[String: Any]?>) -> () = { _ in }
        _ = mockedDataSource.when().call(
            withReturnValue:
                mockedDataSource.getMovie(title: "", result: result),
            andArgumentMatching: [Anything(), Anything()]
        ).thenDo { _ in
            self.isRemoteCalled = true
        }
        
        _ = sut.getMovie(title: "")
        _ = waitForPromises(timeout: 2)
        
        expect(self.isRemoteCalled).to(beTrue())
    }
    
    func test_getMovieList_should_be_called() {
        let result: (Result<[String: Any]?>) -> () = { _ in }
        _ = mockedDataSource.when().call(
            withReturnValue:
                mockedDataSource.getMovieList(search: "", page: 0, result: result),
            andArgumentMatching: [Anything(), Anything(), Anything()]
        ).thenDo { _ in
            self.isRemoteCalled = true
        }
        
        _ = sut.getMovieList(search: "", page: 0)
        _ = waitForPromises(timeout: 2)
        
        expect(self.isRemoteCalled).to(beTrue())
    }
}

