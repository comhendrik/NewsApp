//
//  ArticleViews.swift
//  NewsApp
//
//  Created by Hendrik Steen on 23.07.22.
//

import SwiftUI

struct ArticleOverviewView: View {
    let article: Article
    var body: some View {
        HStack {
            VStack {
                ArticleImageView(url: article.urlToImage ?? "no url", divideScreenWidthBy: 4, cornerRadius: 5)
                Spacer()
            }
            
            Text(article.title ?? "no title")
                .foregroundColor(.black)
        }
    }
}

struct ArticleDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let article: Article
    var body: some View {
        VStack {
            ArticleImageView(url: article.urlToImage ?? "no url", cornerRadius: 20)
                
            ScrollView {
                Text(article.title ?? "no title")
                    .foregroundColor(.black)
                Text("By \(article.author ?? "no author"), published at \(article.publishedAt ?? "unknown"), published in \(article.source.name ?? "unknown")")
                Text(article.description ?? "no description")
                Text(article.content ?? "no content")
            }
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                })
            })
            
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Link(destination: URL(string: article.id ?? "no url") ?? URL(string: "https://google.com")!, label: {
                    Image(systemName: "doc.richtext")
                        .foregroundColor(.white)
                        .font(.title2)
                })
            })
        }
    }
}



