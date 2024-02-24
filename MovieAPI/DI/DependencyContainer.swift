//
//  DependencyContainer.swift
//  MovieAPI
//
//  Created by Bangkit on 27/01/24.
//

import Foundation

class DependencyContainer: ObservableObject {
    var movie: MovieInjector
    var movieAPI: MovieApiInjector
    
    init() {
        self.movie = MovieInjector()
        self.movieAPI = MovieApiInjector()
    }
}
