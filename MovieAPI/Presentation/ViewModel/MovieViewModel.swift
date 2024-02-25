//
//  MovieViewModel.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation

@MainActor
class MovieViewModel: ObservableObject {
    private var getMovieUseCase = MovieInjector.shared.getMovieUseCase
    private var userDefaults = MovieApiInjector.shared.userDefaults
    private var networkAvailability = MovieApiInjector.shared.networkAvailabilityChecker
    
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var movie: Movie = Movie()
    @Published var movieList: [Movie] = []
    @Published var currencies: [String] = []
    
    @Published var title: String = ""
    @Published var debounceTitle: String = ""
    
    init() {
        setupTitleDebounce()
    }
    
    func setupTitleDebounce() {
        debounceTitle = title
        $title
            .debounce(for: .seconds(0.75), scheduler: RunLoop.main)
            .assign(to: &$debounceTitle)
    }
    
    func getMovie(title: String = "") {
        if let currentMovie = getCurrentMovie(), title == "" {
            movie = currentMovie
        } else if title != "" {
            let titleEncoded: String = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            networkAvailability.startListening { [weak self] status in
                switch status {
                case .notReachable:
                    self?.isError = true
                case .reachable(.ethernetOrWiFi):
                    self?.fetchMovie(title: titleEncoded)
                case .reachable(.cellular):
                    self?.fetchMovie(title: titleEncoded)
                case .unknown:
                    self?.fetchMovie(title: titleEncoded)
                }
            }
        }
    }
    
    private func getCurrentMovie() -> Movie? {
        guard let movieCache = userDefaults.object(forKey: Constant.MOVIE) as? [String: Any]
            else { return nil }
        guard let movie = Movie(JSON: movieCache) else { return nil }
        
        return movie
    }
    
    private func fetchMovie(title: String) {
        isLoading = true
        getMovieUseCase.execute(title: title)
            .then { [weak self] response in
                guard let ws = self else { return }
                print(response.toJSON())
                ws.isLoading = false
                ws.isError = false
                ws.movie = response

                if response.title != "" {
                    ws.saveStorage(movie: response)
                }
            }.catch { [weak self] error in
                guard let ws = self else { return }
                ws.isLoading = false
                ws.isError = true
            }
    }
    
    private func saveStorage(movie: Movie) {
        userDefaults.setValue(movie.toJSON(), forKey: Constant.MOVIE)
    }
}
