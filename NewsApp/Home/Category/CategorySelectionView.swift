//
//  CategorySelectionView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 26.07.22.
//

//this file provides the possibilty to change the given category for reading articles with a nice menu

import SwiftUI

struct CategorySelectionMenu: View {
    @EnvironmentObject private var apicaller: APICaller
    let categorys: [Category]
    @State private var showCategoryChangingView = false
    let usedCategorys: [Category]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categorys) { category in
                    if usedCategorys.contains(category) {
                        CategoryMenuButton(currentCategory: apicaller.currentCategory, category: category) {
                            //changing category and fetching articles when there are no articles for this category
                            withAnimation() {
                                apicaller.currentCategory = category
                            }
                            apicaller.fetchArticlesByCategory()
                        }
                    }
                }
                
                Button(action: {
                    apicaller.currentCategory = .general
                    showCategoryChangingView.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color("black"))
                })
            }
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showCategoryChangingView) {
            CategoryAddSettingsView(categorys: categorys, showCategoryChangingView: $showCategoryChangingView)
        }
    }
}

struct CategoryMenuButton: View {
    var currentCategory: Category
    var category: Category
    let action: () -> Void
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text("\(category.emojiValue) \(category.stringValue)")
                    .foregroundColor(currentCategory == category ? Color("black") : .gray)
                    .fontWeight(currentCategory == category ? .heavy : .light)
            }
            .padding(.horizontal, currentCategory == category ? 10 : 5)
            if currentCategory == category {
                CustomDivider(color: Color("black"), width: 3, cornerRadius: 15)
            }
        }
    }
}
