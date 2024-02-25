//
//  GetMovieListUseCase.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Promises

protocol GetMovieListUseCase {
    func execute(search: String, page: Int) -> Promise<[Movie]>
}

struct GetMovieListUseCaseImpl: GetMovieListUseCase {
    var repository: MovieRepository
    
    func execute(search: String, page: Int) -> Promise<[Movie]> {
        repository.getMovieList(search: search, page: page)
    }
}
