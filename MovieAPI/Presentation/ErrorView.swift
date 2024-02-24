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
        Text("Error")
            .font(.title2)
            .fontWeight(.semibold)
        Button("Try Again", action: onTapButton)
            .padding(8)
            .font(.body)
            .fontWeight(.semibold)
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView()
//    }
//}
