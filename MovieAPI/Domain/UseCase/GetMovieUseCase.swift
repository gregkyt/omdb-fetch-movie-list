//
//  GetMovieUseCase.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Promises

protocol GetMovieUseCase {
    func execute(title: String) -> Promise<Movie>
}

struct GetMovieUseCaseImpl: GetMovieUseCase {
    var repository: MovieRepository
    
    func execute(title: String) -> Promise<Movie> {
        repository.getMovie(title: title)
    }
}
