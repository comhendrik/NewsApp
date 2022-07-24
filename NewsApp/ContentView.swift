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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categorys) { category in
                            if usedCategorys.contains(category) {
                                VStack {
                                    Button {
                                        withAnimation() {
                                            apicaller.currentCategory = category
                                        }
                                        Task {
                                            
                                            //TODO: find way to only call fetching once after launching app
                                            
                                           // await acaller.fetchArticles(category: category.queryValue, country: acaller.countryForFetching)
                                        }
                                    } label: {
                                        Text(category.stringValue)
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
                ArticleList(articles: apicaller.articles)
                
                
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
