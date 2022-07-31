//
//  SearchView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 25.07.22.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchPhrase: String
    @EnvironmentObject var controller: PersistenceController
    var searchFunction: (String) -> Void
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search…", text: $searchPhrase)
            if searchPhrase != ""{
                Button {
                    withAnimation() {
                        searchPhrase = ""
                    }
                    
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }

            }
            Button {
                withAnimation() {
                    
                    //closing keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    //performing search
                    searchFunction(searchPhrase)
                    
                    //saving
                    controller.saveSearchHistoryRecord(with: searchPhrase)
                    searchPhrase = ""
                }
            } label: {
                Text("Search")
                    .foregroundColor(.gray)
            }
            .disabled(searchPhrase == "")
            
            

        }
        .padding()
        .background(Color.gray.opacity(0.1).cornerRadius(30))
        .padding([.horizontal,.bottom])
    }
}
