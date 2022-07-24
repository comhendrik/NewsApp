//
//  ContentView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var acaller = APICaller()
    let categories: [Category] = [.business,.entertainment,.general,.health,.science,.sports,.technology]
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories) { category in
                            VStack {
                                Button {
                                    withAnimation() {
                                        acaller.currentCategory = category
                                    }
                                    Task {
                                        
                                        //TODO: find way to only call fetching once after launching app
                                        
                                       // await acaller.fetchArticles(category: category.queryValue, country: acaller.countryForFetching)
                                    }
                                } label: {
                                    Text(category.stringValue)
                                        .foregroundColor(acaller.currentCategory == category ? .black : .gray)
                                        .fontWeight(acaller.currentCategory == category ? .heavy : .light)
                                }
                                .padding(.horizontal, acaller.currentCategory == category ? 10 : 5)
                                if acaller.currentCategory == category {
                                    CustomDivider(color: .black, width: 3, cornerRadius: 15)
                                }
                            }

                        }
                    }
                }
                .padding(.horizontal)
                ArticleList(articles: acaller.articles)
                
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Text("News")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.horizontal, .top])
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
