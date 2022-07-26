//
//  CategorySelectionView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 26.07.22.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject private var apicaller: APICaller
    let categorys: [Category]
    @Binding var showCategoryChangingView: Bool
    let usedCategorys: [Category]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categorys) { category in
                    if usedCategorys.contains(category) {
                        MenuCategoryButton(currentCategory: apicaller.currentCategory, category: category) {
                            //changing category and fetching articles when there are no articles for this category
                            Task { @MainActor in
                                withAnimation() {
                                    apicaller.currentCategory = category
                                }
                                
                                if apicaller.articles[apicaller.currentCategory.arrayIndex].count == 0 {
                                    apicaller.articles[apicaller.currentCategory.arrayIndex] = await apicaller.fetchArticlesByCategory(category: apicaller.currentCategory.queryValue, country: apicaller.countryForFetching)
                                }
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
    }
}

struct MenuCategoryButton: View {
    var currentCategory: Category
    var category: Category
    let action: () -> Void
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text("\(category.emojiValue) \(category.stringValue)")
                    .foregroundColor(currentCategory == category ? .black : .gray)
                    .fontWeight(currentCategory == category ? .heavy : .light)
            }
            .padding(.horizontal, currentCategory == category ? 10 : 5)
            if currentCategory == category {
                CustomDivider(color: .black, width: 3, cornerRadius: 15)
            }
        }
    }
}
