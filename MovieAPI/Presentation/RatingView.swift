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
