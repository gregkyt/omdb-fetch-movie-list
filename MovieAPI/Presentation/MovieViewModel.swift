//
//  MovieViewModel.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    private var getMovieUseCase = MovieInjector.shared.getMovieUseCase
    private var userDefaults = MovieApiInjector.shared.userDefaults
    private var networkAvailability = MovieApiInjector.shared.networkAvailabilityChecker
    
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var movie: Movie = Movie()
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
                print(status)
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
    
    /*func getMovie() {
        guard let updatedAt = userDefaults.object(forKey: Constant.UPDATED_AT) as? Int64 else {
            return fetchLatest()
        }
        
        let isRefresh: Bool = (Int64(Date().timeInterval1970ToSecond()) - updatedAt) > 1800 // 30 mins = 60 * 30 = 1800
        if isRefresh {
            fetchLatest()
        } else if let latestJson = getLatestLocal() {
            latest = latestJson
            rates = latestJson.rates
        }
    }
    
    func getCurrencies() {
        isLoading = true
        currenciesUseCase.execute()
            .then { [weak self] response in
                guard let ws = self else { return }
                ws.isLoading = false
                ws.currencies = Array(response.keys).sorted(by: <)
            }.catch { [weak self] error in
                guard let ws = self else { return }
                ws.isLoading = false
                ws.isError = true
            }
    }
    
    func updateLatest(rate: Double = 0.0, currency: String = "USD") {
        isLoading = true
        if currency != "USD" {
            rates = latest.rates
            let MovieRates = currencyConverter.parse(currency: currency)
            for (key, _) in rates {
                let formattedResult = currencyConverter
                    .convertAndFormat(MovieRates, value: rate, valueCurrency: key)
                rates[key] = formattedResult ?? 0.0
            }
        } else {
            rates = latest.rates
            for (key, value) in rates {
                rates[key] = (value as? Double ?? 0) * rate
            }
        }
        isLoading = false
    }*/
    
    /*func getLatestLocal() -> Latest? {
        guard let latestCache = userDefaults.object(forKey: Constant.LATEST) as? [String: Any]
            else { return nil }
        guard let latestJson = Latest(JSON: latestCache) else { return nil }
        
        return latestJson
    }
    
    private func fetchLatest(currency: String = "USD") {
        isLoading = true
        latestUseCase.execute(currency: currency)
            .then { [weak self] response in
                guard let ws = self else { return }
                print(response.toJSON())
                ws.isLoading = false
                ws.latest = response
                ws.rates = response.rates
                
                ws.saveStorage(latest: response)
            }.catch { [weak self] error in
                guard let ws = self else { return }
                ws.isLoading = false
                ws.isError = true
                if let latestJson = ws.getLatestLocal() {
                    ws.latest = latestJson
                    ws.rates = latestJson.rates
                }
            }
    }
    
    private func saveStorage(movie: Movie) {
        userDefaults.setValue(movie.toJSON(), forKey: Constant.MOVIE)
        userDefaults.setValue(Date().timeInterval1970ToSecond(), forKey: Constant.UPDATED_AT)
    }*/
}
