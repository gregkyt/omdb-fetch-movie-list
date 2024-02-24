//
//  LatestInjector.swift
//  MovieAPI
//
//  Created by Bangkit on 26/01/24.
//

import Foundation

class MovieApiInjector {
    static let shared = MovieApiInjector()
    
    lazy var userDefaults: UserDefaults = {
        UserDefaults.standard
    }()
    
    lazy var networkAvailabilityChecker: NetworkAvailabilityChecker = {
        NetworkAvailabilityCheckerImpl.shared
    }()
}
