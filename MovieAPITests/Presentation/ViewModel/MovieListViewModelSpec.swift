//
//  MovieListViewModelSpec.swift
//  MovieAPITests
//
//  Created by Bangkit on 26/02/24.
//

import XCTest
import Promises
import Mockit
import Nimble
@testable import Alamofire
@testable import Promises
@testable import MovieAPI

final class MovieListViewModelSpec: XCTestCase {
    var sut: MovieListViewModel!
    var mockedGetMovieListUseCase: MockedGetMovieListUseCase!
    var mockedNetworkAvailability: MockedNetworkAvailabilityChecker!
    var mockedUserDefaults: MockedUserDefaults!
    
    @MainActor override func setUp() {
        sut = MovieListViewModel()
        mockedGetMovieListUseCase = MockedGetMovieListUseCase(testCase: self)
        mockedNetworkAvailability = MockedNetworkAvailabilityChecker(testCase: self)
        mockedUserDefaults = MockedUserDefaults(testCase: self)
        sut.getMovieListUseCase = mockedGetMovieListUseCase
        sut.networkAvailability = mockedNetworkAvailability
        sut.userDefaults = mockedUserDefaults
    }
    
    override func tearDown() {
        sut = nil
        mockedGetMovieListUseCase = nil
    }
    
    @MainActor func test_getMovieListFromLocal() {
        let movie: [String: Any] = getMovieMock()
        _ = mockedUserDefaults.when().call(
            withReturnValue:
                mockedUserDefaults.object(forKey: Constant.MOVIE_LIST)
        ).thenReturn([movie])
        
        sut.getMovieList()
        
        expect(self.sut.movieList.count).to(equal(1))
    }
    
    @MainActor func test_getCurrentMovies() {
        let movie: [String: Any] = getMovieMock()
        _ = mockedUserDefaults.when().call(
            withReturnValue:
                mockedUserDefaults.object(forKey: Constant.MOVIE_LIST)
        ).thenReturn([movie])
        
        let movies = sut.getCurrentMovies()
        
        expect(movies?.count).to(equal(1))
    }
    
    @MainActor func test_fetchMovieList() {
        guard let movie: Movie = Movie(JSON: getMovieMock()) else { return }
        let promise: Promise<[Movie]> = Promise { [movie] }
        _ = mockedGetMovieListUseCase.when().call(
            withReturnValue:
                mockedGetMovieListUseCase.execute(search: "galaxy", page: 1)
        ).thenReturn(promise)
        
        sut.fetchMovieList(search: "galaxy")
        _ = waitForPromises(timeout: 2)
        
        expect(self.sut.movieList.count).to(equal(1))
    }
    
    @MainActor func test_saveStorage() {
        guard let movie: Movie = Movie(JSON: getMovieMock()) else { return }
        let movies: [Movie] = [movie]
        
        sut.saveStorage(movies: movies)
        
        mockedUserDefaults.verify(verificationMode: Once())
            .set(movies.toJSON(), forKey: Constant.MOVIE_LIST)
    }
    
    @MainActor func test_reachable() {
        var status: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
        let completion: (NetworkReachabilityManager.NetworkReachabilityStatus) -> () = { _ in }
        
        _ = mockedNetworkAvailability.when().call(
            withReturnValue:
                mockedNetworkAvailability.startListening(completion: completion),
            andArgumentMatching: [Anything()]
        ).thenAnswer { _ in
            status = .reachable(.ethernetOrWiFi)
        }
        
        sut.getMovieList(search: "galaxy", isRefresh: false)
        
        expect(status).to(equal(.reachable(.ethernetOrWiFi)))
        mockedNetworkAvailability.verify(verificationMode: Once())
            .startListening(completion: completion)
    }
    
    @MainActor func test_notReachable() {
        var status: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
        let completion: (NetworkReachabilityManager.NetworkReachabilityStatus) -> () = { _ in }
        
        _ = mockedNetworkAvailability.when().call(
            withReturnValue:
                mockedNetworkAvailability.startListening(completion: completion),
            andArgumentMatching: [Anything()]
        ).thenAnswer { _ in
            status = .notReachable
        }
        
        sut.getMovieList(search: "galaxy", isRefresh: false)
        
        expect(status).to(equal(.notReachable))
        mockedNetworkAvailability.verify(verificationMode: Once())
            .startListening(completion: completion)
    }
    
    func getMovieMock() -> [String: Any] {
        let movie: [String: Any] = [
            "Title": "Guardians of the Galaxy",
            "Year":"2014",
            "imdbID":"tt2015381"
        ]
        
        return movie
    }
}
