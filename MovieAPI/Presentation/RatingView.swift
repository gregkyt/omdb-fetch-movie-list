//
//  RatingView.swift
//  MovieAPI
//
//  Created by Bangkit on 24/02/24.
//

import Foundation
import SwiftUI

struct RatingView: View {
    let source: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(source)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// public struct RatingView: View {
//    var rating: Decimal
//    var color: Color
//    var backgroundColor: Color
//
//    public init(
//        rating: Decimal,
//        color: Color = .red,
//        backgroundColor: Color = .gray
//    ) {
//        self.rating = rating
//        self.color = color
//        self.backgroundColor = backgroundColor
//    }
//
//    public var body: some View {
//        ZStack {
//            BackgroundStars(backgroundColor)
//            ForegroundStars(rating: rating, color: color)
//        }
//    }
// }

private struct StarImage: View {
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}


private struct BackgroundStars: View {
    var color: Color

    init(_ color: Color) {
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { _ in
                StarImage()
            }
        }.foregroundColor(color)
    }
}


private struct ForegroundStars: View {
    var rating: Decimal
    var color: Color

    init(rating: Decimal, color: Color) {
        self.rating = rating
        self.color = color
    }

    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                RatingStar(
                    rating: self.rating,
                    color: self.color,
                    index: index
                )
            }
        }
    }
}
