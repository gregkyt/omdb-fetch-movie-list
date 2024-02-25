//
//  MovieAPIApp.swift
//  MovieAPI
//
//  Created by Bangkit on 23/02/24.
//

import SwiftUI

@main
struct MovieAPIApp: App {
    var body: some Scene {
        WindowGroup {
            // ContentView()
            // MovieView().environmentObject(DependencyContainer())
            MovieListView().environmentObject(DependencyContainer())
        }
    }
}
