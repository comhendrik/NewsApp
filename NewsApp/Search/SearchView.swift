//
//  SearchView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 25.07.22.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchPhrase: String
    @Binding var searchPerformed: Bool
    @EnvironmentObject var controller: PersistenceController
    var searchFunction: (String) -> Void
    
    var closeFunction: () -> Void
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search…", text: $searchPhrase)
            Button {
                withAnimation() {
                    //performing search
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    searchFunction(searchPhrase)
                    searchPerformed = true
                    
                    //saving
                    controller.saveSearchHistoryRecord(with: searchPhrase)
                    searchPhrase = ""
                }
            } label: {
                Text("Search")
                    .foregroundColor(.gray)
            }
            .disabled(searchPhrase == "")
            
            if searchPerformed || searchPhrase != ""{
                Button {
                    withAnimation() {
                        searchPhrase = ""
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
