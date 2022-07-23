//
//  ArticleList.swift
//  NewsApp
//
//  Created by Hendrik Steen on 23.07.22.
//

//List view for section of articles

import SwiftUI

struct ArticleList: View {
    
    let articles: [Article]
    
    var body: some View {
        List {
            ForEach(articles) { article in
                NavigationLink(destination: {
                    ArticleDetailView(article: article)
                }, label: {
                    ArticleOverviewView(article: article)
                })
                .listRowSeparator(.hidden)
            }
            
        }
        .listStyle(.plain)
    }
}

