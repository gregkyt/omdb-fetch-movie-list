//
//  GetLatestUseCaseSpec.swift
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

final class GetLatestUseCaseSpec: XCTestCase {
    var mockedRepository: MockedMovieRepository!
    
    override func setUp() {
        mockedRepository = MockedMovieRepository(testCase: self)
    }
    
    override func tearDown() {
        mockedRepository = nil
    }
    
    func test_execute_should_be_success() {
        guard let movie: Movie = Movie(JSON: [
            "Title": "Guardians of the Galaxy",
            "Year":"2014",
            "imdbID":"tt2015381"
        ]) else { return }
        let promise: Promise<[Movie]> = Promise { [movie] }
        _ = mockedRepository.when().call(
            withReturnValue:
                mockedRepository.getMovieList(search: "", page: 0)
        ).thenReturn(promise)
        
        let response = sut(repository: mockedRepository).execute(search: "", page: 0)
        _ = waitForPromises(timeout: 1)
        
        expect(response.value).toNot(beNil())
        expect(response.error).to(beNil())
    }
    
    func test_execute_should_be_failed() {
        let error: NSError = NSError(domain: "Forbidden", code: 403)
        let promise: Promise<[Movie]> = Promise { error }
        _ = mockedRepository.when().call(
            withReturnValue:
                mockedRepository.getMovieList(search: "", page: 0)
        ).thenReturn(promise)
        
        let response = sut(repository: mockedRepository).execute(search: "", page: 0)
        _ = waitForPromises(timeout: 1)
        
        expect(response.value).to(beNil())
        expect(response.error).toNot(beNil())
    }
    
    func sut(repository: MockedMovieRepository) -> GetMovieListUseCaseImpl {
        return GetMovieListUseCaseImpl(repository: repository)
    }
}
