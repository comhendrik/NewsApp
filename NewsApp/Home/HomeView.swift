//
//  HomeView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 31.07.22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var apicaller: APICaller
    let categorys: [Category] = [.general,.business,.entertainment,.health,.science,.sports,.technology]
    @AppStorage("categorys") var usedCategorys = CategoryArray()
    @FocusState private var isFocused: Bool
    @State private var searchPhrase = ""
    @State private var lastSearchPhrase = ""
    @State private var searchPerformed = false
    @EnvironmentObject var controller: PersistenceController
    var body: some View {
        NavigationView {
            VStack {
                SearchView(searchPhrase: $searchPhrase) { searchPhraseForSearch in
                    lastSearchPhrase = searchPhraseForSearch
                    //searching articles with search Phrase
                    apicaller.fetchArticlesBySearchPhrase(searchPhrase: searchPhraseForSearch)
                }
                .focused($isFocused)
                
                
                //show SearchHistoryView when users clicks on text field of SearchView
                if isFocused {
                    SearchHistoryView(searchPhrase: $searchPhrase)
                } else {
                    if apicaller.currentCategory == .search {
                        VStack {
                            HStack {
                                Text("\(apicaller.currentCategory.emojiValue) \(apicaller.currentCategory.stringValue) Results for")
                                    .fontWeight(.bold)
                                Button {
                                    searchPhrase = lastSearchPhrase
                                    isFocused.toggle()
                                } label: {
                                    Text(lastSearchPhrase)
                                }

                                Spacer()
                                Button {
                                    apicaller.currentCategory = .general
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    } else {
                        CategorySelectionMenu(categorys: categorys, usedCategorys: usedCategorys)
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
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Text("News")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.horizontal, .top])
                })
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    CountrySettingsView()
                })
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
