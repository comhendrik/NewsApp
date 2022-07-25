//
//  ContentView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var apicaller: APICaller
    let categorys: [Category] = [.general,.business,.entertainment,.health,.science,.sports,.technology]
    @AppStorage("categorys") var usedCategorys = CategoryArray()
    @State private var showCategoryChangingView = false
    var body: some View {
        NavigationView {
            VStack {
                SearchView { searchPhrase in
                    Task { @MainActor in
                        //fetching articles from search phrase
                        apicaller.currentCategory = .search
                        
                        
                        //real search function wont be called because i dont want to query all the time when testing ui changes
                        //await apicaller.fetchArticlesBySearchPhrase(searchPhrase: searchPhrase)
                    }
                } closeFunction: {
                    Task { @MainActor in
                        //fetching new articles when closing search view when there are no articles
                        apicaller.currentCategory = .general
                        if apicaller.articles[apicaller.currentCategory.arrayIndex].count == 0 {
                            apicaller.articles[apicaller.currentCategory.arrayIndex] = await apicaller.fetchArticlesByCategory(category: apicaller.currentCategory.queryValue, country: apicaller.countryForFetching)
                        }
                    }
                }

                if apicaller.currentCategory != .search {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categorys) { category in
                                if usedCategorys.contains(category) {
                                    VStack {
                                        Button {
                                            //changing category and fetching articles when there are no articles for this category
                                            Task { @MainActor in
                                                withAnimation() {
                                                    apicaller.currentCategory = category
                                                }
                                                
                                                if apicaller.articles[apicaller.currentCategory.arrayIndex].count == 0 {
                                                    apicaller.articles[apicaller.currentCategory.arrayIndex] = await apicaller.fetchArticlesByCategory(category: apicaller.currentCategory.queryValue, country: apicaller.countryForFetching)
                                                }
                                                print(apicaller.articles[0])
                                            }
                                        } label: {
                                            Text("\(category.emojiValue ) \(category.stringValue)")
                                                .foregroundColor(apicaller.currentCategory == category ? .black : .gray)
                                                .fontWeight(apicaller.currentCategory == category ? .heavy : .light)
                                        }
                                        .padding(.horizontal, apicaller.currentCategory == category ? 10 : 5)
                                        if apicaller.currentCategory == category {
                                            CustomDivider(color: .black, width: 3, cornerRadius: 15)
                                        }
                                    }
                                }

                            }
                            Button(action: {
                                showCategoryChangingView.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                            })
                        }
                    }
                    .padding(.horizontal)
                } else {
                    VStack {
                        HStack {
                            Text("\(apicaller.currentCategory.emojiValue) \(apicaller.currentCategory.stringValue)")
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                    }
                }
                //TODO: do not repeat code
                switch apicaller.currentCategory {
                case .search:
                    ArticleList(articles: apicaller.articles[0])
                case .general:
                    ArticleList(articles: apicaller.articles[1])
                case .business:
                    ArticleList(articles: apicaller.articles[2])
                case .entertainment:
                    ArticleList(articles: apicaller.articles[3])
                case .health:
                    ArticleList(articles: apicaller.articles[4])
                case .science:
                    ArticleList(articles: apicaller.articles[5])
                case .sports:
                    ArticleList(articles: apicaller.articles[6])
                case .technology:
                    ArticleList(articles: apicaller.articles[7])
                }
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Text("News")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.horizontal, .top])
                })
            }
            .fullScreenCover(isPresented: $showCategoryChangingView) {
                CategoryView(categorys: categorys, showCategoryChangingView: $showCategoryChangingView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
