//
//  SearchView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 25.07.22.
//

import SwiftUI

struct SearchView: View {
    @State private var searchPhrase = ""
    var searchFunction: (String) -> Void
    @State private var searchPerformed = false
    var closeFunction: () -> Void
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search…", text: $searchPhrase)
            Button {
                withAnimation() {
                    searchFunction(searchPhrase)
                    searchPerformed = true
                }
            } label: {
                Text("Search")
                    .foregroundColor(.gray)
            }
            
            if searchPerformed {
                Button {
                    withAnimation() {
                        searchPerformed = false
                        closeFunction()
                    }
                    
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }

            }

        }
        .padding()
        .background(Color.gray.opacity(0.1).cornerRadius(30))
        .padding([.horizontal,.bottom])
    }
}
