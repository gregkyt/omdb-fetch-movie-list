//
//  MovieListView.swift
//  MovieAPI
//
//  Created by Bangkit on 24/02/24.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieListViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Title", text: $viewModel.title)
                .onChange(of: viewModel.debounceTitle) { title in
                    viewModel.getMovieList(
                        search: title,
                        isRefresh: true
                    )
                }
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray)
                )
            if viewModel.isError {
                ErrorView(onTapButton: {
                    viewModel.getMovieList(
                        search: viewModel.debounceTitle,
                        isRefresh: true
                    )
                })
            } else {
                movieList
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            viewModel.getMovieList(search: viewModel.debounceTitle)
        }
    }
}

extension MovieListView {
    var movieList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                if viewModel.isLoading && viewModel.movieList.isEmpty {
                    ForEach((0...4), id: \.self) { data in
                        ItemMovieView(
                            imageUrl: "https://m.media-amazon.com/images/M/MV5BMTc5MTE4MzY2N15BMl5BanBnXkFtZTcwNjMwNDc3Ng@@._V1_SX300.jpg",
                            title: "Iron Man",
                            year: "2002",
                            isLoading: viewModel.isLoading
                        )
                    }
                } else {
                    ForEach(viewModel.movieList, id: \.imdbID) { data in
                        ItemMovieView(
                            imageUrl: data.poster,
                            title: data.title,
                            year: data.year,
                            isLoading: viewModel.isLoading
                        )
                        .onAppear {
                            viewModel.onLoadMoreMovieList(
                                search: viewModel.debounceTitle,
                                movie: data
                            )
                        }
                        
                        if viewModel.movieList.last?.title != data.title {
                            Divider()
                        }
                    }
                }
            }
        }
        .refreshable {
            viewModel.getMovieList(
                search: viewModel.debounceTitle,
                isRefresh: true
            )
        }
    }
}

//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView()
//    }
//}
