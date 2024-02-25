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
    
    func getMovieList(search: String, page: Int) -> Promise<[Movie]> {
        return Promise<[Movie]>(on: .global(qos: .utility)) { fullfilled, reject in
            remote.getMovieList(search: search, page: page) { result in
                switch (result) {
                case .success(let data):
                    guard let data = data else { return }
                    if let searchList = data["Search"] as? [[String: Any]] {
                        var movieList: [Movie] = []
                        for list in searchList {
                            guard let json = Movie(JSON: list) else { return }
                            movieList.append(json)
                        }
                        fullfilled(movieList)
                    } else {
                        let error = NSError(domain: "Error", code: 500, userInfo: data)
                        reject(error as Error);
                    }
                case .failure(let error):
                    reject(error);
                }
            }
        }
    }
}

