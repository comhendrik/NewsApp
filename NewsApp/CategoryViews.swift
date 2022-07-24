//
//  CategoryViews.swift
//  NewsApp
//
//  Created by Hendrik Steen on 24.07.22.
//

import SwiftUI

struct CategoryView: View {
    let categorys: [Category]
    @Binding var showCategoryChangingView: Bool
    @AppStorage("categorys") var usedCategorys = CategoryArray()
    var body: some View {
        VStack {
            
            
            HStack {
                Text("Add categorys to your site")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.horizontal,.top])
            HStack {
                Text("General is always selected")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray.opacity(0.5))
                Spacer()
            }
            .padding(.horizontal)
            
            
            LazyVGrid(columns: [GridItem(),GridItem()]) {
                ForEach(categorys) { category in
                    CategoryButton(category: category, usedCategorys: $usedCategorys)
                }
            }
            .padding()
            
            Button {
                showCategoryChangingView.toggle()
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.frame(width: UIScreen.main.bounds.width - UIScreen.main.bounds.width / 10).cornerRadius(20))
                    
            }

        }
    }
}

struct CategoryButton: View {
    let category: Category
    @Binding var usedCategorys: [Category]
    var body: some View {
        Button {
            if usedCategorys.contains(category) {
                for i in 0 ..< usedCategorys.count {
                    if usedCategorys[i] == category {
                        usedCategorys.remove(at: i)
                        break
                    }
                }
            } else {
                usedCategorys.append(category)
            }
        } label: {
            ZStack {
                Circle()
                    .strokeBorder(usedCategorys.contains(category) ? Color.black.opacity(0.75) : Color.gray.opacity(0.25), lineWidth: 2)
                    .background(Circle().foregroundColor(usedCategorys.contains(category) ? Color.gray.opacity(0.25): Color.white))
                    .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
                VStack {
                    Text(category.emojiValue)
                    Text(category.stringValue)
                        .foregroundColor(.black)
                        .font(.callout)
                }
            
            }
        }
        .disabled(category == .general)

        
    }
}
