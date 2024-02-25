//
//  MovieRepository.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Promises

protocol MovieRepository {
    func getMovie(title: String) -> Promise<Movie>
    func getMovieList(search: String, page: Int) -> Promise<[Movie]>
}
