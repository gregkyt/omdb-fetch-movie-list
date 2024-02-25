//
//  ItemMovieView.swift
//  MovieAPI
//
//  Created by Bangkit on 24/02/24.
//

import SwiftUI
import Kingfisher

struct ItemMovieView: View {
    let imageUrl: String
    let title: String
    let year: String
    let isLoading: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            KFImage(URL(string: imageUrl))
                .fade(duration: 0.25)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
                .clipped()
                .frame(maxWidth: 100, maxHeight: 100)
                .redacted(reason: isLoading ? .placeholder : [])
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .redacted(reason: isLoading ? .placeholder : [])
                Text(year)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .redacted(reason: isLoading ? .placeholder : [])
            }
        }
    }
}

struct ItemMovieView_Previews: PreviewProvider {
    static var previews: some View {
        ItemMovieView(imageUrl: "https://m.media-amazon.com/images/M/MV5BMTc5MTE4MzY2N15BMl5BanBnXkFtZTcwNjMwNDc3Ng@@._V1_SX300.jpg", title: "Man on a Ledge", year: "2002", isLoading: true)
    }
}
