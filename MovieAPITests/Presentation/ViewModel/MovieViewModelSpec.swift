//
//  MovieViewModelSpec.swift
//  MovieAPITests
//
//  Created by Bangkit on 25/02/24.
//

import XCTest
import Promises
import Mockit
import Nimble
@testable import Promises
@testable import MovieAPI

final class MovieViewModelSpec: XCTestCase {
    var sut: MovieViewModel!
    var mockedGetMovieUseCase: MockedGetMovieUseCase!
    
    @MainActor override func setUp() {
        sut = MovieViewModel()
        mockedGetMovieUseCase = MockedGetMovieUseCase(testCase: self)
        sut.getMovieUseCase = mockedGetMovieUseCase
    }
    
    override func tearDown() {
        sut = nil
        mockedGetMovieUseCase = nil
    }
    
    @MainActor func test_getMovie() {
        guard let movie: Movie = Movie(JSON: [
            "Title": "Guardians of the Galaxy",
            "Year":"2014",
            "imdbID":"tt2015381"
        ]) else { return }
        let promise: Promise<Movie> = Promise { movie }
        _ = mockedGetMovieUseCase.when().call(
            withReturnValue:
                mockedGetMovieUseCase.execute(title: "galaxy")
        ).thenReturn(promise)
        
        sut.getMovie(title: "galaxy")
        _ = waitForPromises(timeout: 2)
        
        expect(self.sut.movie.title).to(equal("Guardians of the Galaxy"))
    }
}
