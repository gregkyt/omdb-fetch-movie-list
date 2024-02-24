//
//  MovieInjector.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation

class MovieInjector {
    static let shared = MovieInjector()
    
    lazy var apiManager: APIManager = {
        APIManagerImpl()
    }()
    
    lazy var movieDatasource: MovieDataSource = {
        MovieDataSourceImpl(apiManager: apiManager)
    }()
    
    // Repository
    
    lazy var movieRepository: MovieRepository = {
        MovieRepositoryImpl(remote: movieDatasource)
    }()
    
    // UseCase
    
    lazy var getMovieUseCase: GetMovieUseCase = {
        GetMovieUseCaseImpl(repository: MovieInjector.shared.movieRepository)
    }()
}
