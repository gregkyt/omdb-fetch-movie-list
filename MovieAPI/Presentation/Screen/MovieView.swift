//
//  MovieView.swift
//  MovieAPI
//
//  Created by Bangkit on 23/02/24.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: $viewModel.title)
                    .onChange(of: viewModel.debounceTitle) { title in
                        viewModel.getMovie(title: title)
                    }
                    .padding(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray)
                    )
                if viewModel.isError {
                    ErrorView(onTapButton: {
                        viewModel.getMovie(title: viewModel.debounceTitle)
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    if viewModel.movie.title == "" {
                        Text("No Data")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text(viewModel.movie.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .redacted(reason: viewModel.isLoading ? .placeholder : [])
                        header
                        detail
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .task {
                viewModel.getMovie()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension MovieView {
    var header: some View {
        HStack(alignment: .top, spacing: 8) {
            KFImage(URL(string: viewModel.movie.poster))
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .clipped()
                .frame(maxWidth: .infinity)
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
            content
                .frame(maxWidth: .infinity)
        }
    }
}

extension MovieView {
    var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Text("Rilis")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.released)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Genre")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.genre)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Type")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.type.capitalized)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Runtime")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.runtime)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Language")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.language)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Rated")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.rated)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Country")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.country)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
}

extension MovieView {
    var detail: some View {
        VStack(alignment: .leading, spacing: 16) {
            imdb
            castAndCrew
            plot
            if !viewModel.movie.ratings.isEmpty {
                rating
            }
        }
    }
}

extension MovieView {
    var imdb: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("IMDB")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            HStack(alignment: .top, spacing: 8) {
                Text("ID")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.imdbID)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Rating")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.imdbRating)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Votes")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.imdbVotes)
                    .font(.body)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
    
    var castAndCrew: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cast and Crew")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            HStack(alignment: .top, spacing: 8) {
                Text("Writer")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.writer)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            HStack(alignment: .top, spacing: 8) {
                Text("Actors")
                    .font(.body)
                    .fontWeight(.semibold)
                Text(viewModel.movie.actors)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
    
    var plot: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Plot")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            Text(viewModel.movie.plot)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
    }
    
    var rating: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating")
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            ForEach(viewModel.movie.ratings.sorted(by: { $0.source < $1.source }), id: \.source) { item in
                RatingView(source: item.source, value: item.value)
            }
        }
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
    }
}

//struct MovieView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieView()
//    }
//}
