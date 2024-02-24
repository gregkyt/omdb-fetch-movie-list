//
//  MovieRepositoryImpl.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import Promises

struct MovieRepositoryImpl: MovieRepository {
    typealias MovieInstance = (MovieDataSource) -> MovieRepositoryImpl
    
    fileprivate let remote: MovieDataSource
    
    init(remote: MovieDataSource) {
        self.remote = remote
    }
    
    static let sharedInstance: MovieInstance = { remoteRepo in
        return MovieRepositoryImpl(remote: remoteRepo)
    }
    
    func getMovie(title: String) -> Promise<Movie> {
        return Promise<Movie>(on: .global(qos: .utility)) { fullfilled, reject in
            remote.getMovie(title: title) { result in
                switch (result) {
                case .success(let data):
                    guard let data = data, let json = Movie(JSON: data) else { return }
                    fullfilled(json)
                case .failure(let error):
                    reject(error);
                }
            }
        }
    }
}

