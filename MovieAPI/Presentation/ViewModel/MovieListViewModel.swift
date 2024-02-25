//
//  MovieListViewModel.swift
//  MovieAPI
//
//  Created by Bangkit on 24/02/24.
//

import Foundation

@MainActor
class MovieListViewModel: ObservableObject {
    private var getMovieListUseCase = MovieInjector.shared.getMovieListUseCase
    private var userDefaults = MovieApiInjector.shared.userDefaults
    private var networkAvailability = MovieApiInjector.shared.networkAvailabilityChecker
    
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var movieList: [Movie] = []
    @Published var currencies: [String] = []
    
    @Published var title: String = ""
    @Published var debounceTitle: String = ""
    
    var page: Int = 1
    var errorMessage: String = ""
    
    init() {
        setupTitleDebounce()
    }
    
    func setupTitleDebounce() {
        debounceTitle = title
        $title
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .assign(to: &$debounceTitle)
    }
    
    func getMovieList(search: String = "", isRefresh: Bool = false) {
        if isRefresh {
            movieList = []
            page = 1
        }
        
        if let currentMovies = getCurrentMovies(), title == "" {
            movieList = currentMovies
        } else if search != "" {
            let searchEncoded: String = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            networkAvailability.startListening { [weak self] status in
                switch status {
                case .notReachable:
                    self?.isError = true
                case .reachable(.ethernetOrWiFi):
                    self?.fetchMovieList(search: searchEncoded)
                case .reachable(.cellular):
                    self?.fetchMovieList(search: searchEncoded)
                case .unknown:
                    self?.fetchMovieList(search: searchEncoded)
                }
            }
        }
    }
    
    func onLoadMoreMovieList(search: String = "", movie: Movie) {
        let lastMovie = movieList[movieList.count - 2]
        if lastMovie.imdbID == movie.imdbID {
            page += 1
            fetchMovieList(search: search)
        }
    }
    
    private func getCurrentMovies() -> [Movie]? {
        guard let moviesCache = userDefaults.object(forKey: Constant.MOVIE_LIST) as? [[String: Any]]
            else { return nil }
        var list: [Movie] = []
        for cache in moviesCache {
            guard let movie = Movie(JSON: cache) else { return nil }
            list.append(movie)
        }
        
        return list
    }
    
    private func fetchMovieList(search: String) {
        isLoading = true
        getMovieListUseCase.execute(search: search, page: page)
            .then { [weak self] response in
                guard let ws = self else { return }
                print(response.toJSON())
                ws.isLoading = false
                ws.isError = false
                
                if ws.page == 1 {
                    ws.movieList = response
                } else {
                    ws.movieList.append(contentsOf: response)
                }
                
                if !ws.movieList.isEmpty {
                    ws.saveStorage(movies: ws.movieList)
                }
            }.catch { [weak self] error in
                guard let ws = self else { return }
                ws.isLoading = false
                ws.isError = true
                
                let errUserInfo = (error as NSError).userInfo
                guard let errStr = errUserInfo["Error"] as? String else { return }
                ws.errorMessage = errStr
            }
    }
    
    private func saveStorage(movies: [Movie]) {
        userDefaults.setValue(movies.toJSON(), forKey: Constant.MOVIE_LIST)
    }
}
