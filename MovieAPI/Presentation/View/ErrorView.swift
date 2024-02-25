//
//  ErrorView.swift
//  MovieAPI
//
//  Created by Bangkit on 24/02/24.
//

import SwiftUI

struct ErrorView: View {
    let onTapButton: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            Button("Try Again", action: onTapButton)
                .padding(8)
                .font(.body)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(onTapButton: {
            print("")
        })
    }
}
