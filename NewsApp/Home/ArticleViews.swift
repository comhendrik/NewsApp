//
//  ArticleViews.swift
//  NewsApp
//
//  Created by Hendrik Steen on 23.07.22.
//

//List with articles displayed in the ArticleOverviewView. The ArticleOverviewView directs to its corresponding ArticleDetailView

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

struct ArticleOverviewView: View {
    let article: Article
    var body: some View {
        HStack {
            VStack {
                ArticleImageView(url: article.urlToImage ?? "no url", divideScreenWidthBy: 4, cornerRadius: 5, divideScreenHeightBy: 10)
                Spacer()
            }
            
            Text(article.title ?? "no title")
                .foregroundColor(Color("black"))
        }
    }
}

struct ArticleDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let article: Article
    @State private var heightOfImage: CGFloat = 0.0
    var body: some View {
        
        VStack {
            ArticleImageView(url: article.urlToImage ?? "no url", divideScreenWidthBy: 0, cornerRadius: 0, divideScreenHeightBy: 3)
                .background(
                  GeometryReader { geometryProxy in
                      //creating clear color to get size of vstack view
                    Color.clear
                      .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
                  }
                )
                .onPreferenceChange(SizePreferenceKey.self) { newSize in
                    //passing size of view to variable to make it usable in programm
                    heightOfImage = newSize.height
                }
            VStack {
                VStack {
                    VStack {
                        
                        HStack {
                            Text(article.title ?? "No title")
                                .fontWeight(.bold)
                                .foregroundColor(Color("black"))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                            
                        HStack {
                            Text("published by \(article.source.name ?? "unknown")")
                                .fontWeight(.semibold)
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.75))
                            Spacer()
                        }
                            
                    }
                    .padding([.horizontal, .top])
                    
                    HStack {
                        Text(article.author ?? "no author")
                            .padding(15)
                            .foregroundColor(Color("white"))
                            .background(Color("black").cornerRadius(25))
                        Spacer()
                        Text(createDateFromString(dateStr: article.publishedAt ?? "no date") ?? Date(), style: .date)
                            .padding(15)
                            .background(Color.gray.cornerRadius(25).opacity(0.25))
                        
                    }
                    .padding(.horizontal)
                    
                    Text(article.description ?? "no description")
                        .fontWeight(.semibold)
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                    Text(article.content ?? "no content")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                        
                }
                .background(Color("white").frame(width: UIScreen.main.bounds.width).cornerRadius(20))
            }
            .offset(y: -heightOfImage/8)
            
            Spacer()
        }

            
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.backward.circle.fill")
                        .foregroundColor(Color("white"))
                        .font(.title2)
                })
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                HStack {
                    Link(destination: URL(string: article.id ?? "no url") ?? URL(string: "https://google.com")!, label: {
                        Image(systemName: "doc.text.magnifyingglass")
                            .foregroundColor(Color("white"))
                            .font(.title2)
                    })
                    ShareSheet(article: article)
                }
            })
        }
    }
}



struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private func createDateFromString(dateStr: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"
    let date = dateFormatter.date(from: dateStr)
    return date
}



