//
//  ContentView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var acaller = APICaller()
    var body: some View {
        NavigationView {
            List {
                ForEach(acaller.articles) { article in
                    Text(article.title ?? "no title")
                }
            }
        }
        .task {
            await acaller.fetchArticles()
            print(acaller.articles)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
