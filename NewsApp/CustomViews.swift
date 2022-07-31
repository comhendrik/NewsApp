//
//  CustomViews.swift
//  NewsApp
//
//  Created by Hendrik Steen on 23.07.22.
//

import SwiftUI

struct CustomDivider: View {
    var color: Color = .gray
    var width: CGFloat = 2
    var cornerRadius: CGFloat = 0.0
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .cornerRadius(cornerRadius)
    }
}

//TODO: Do not repeat .frame, .cornerRadius
struct ArticleImageView: View {
    var url: String
    var divideScreenWidthBy: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var divideScreenHeightBy: CGFloat = 0
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Rectangle()
                        .frame(width: abs(UIScreen.main.bounds.width / divideScreenWidthBy), height: abs(UIScreen.main.bounds.height / divideScreenHeightBy))
                        .cornerRadius(cornerRadius)
                        .foregroundColor(.gray.opacity(0.75))
                    ProgressView()
                }
            case .success(let image):
                image.resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: abs(UIScreen.main.bounds.width / divideScreenWidthBy))
                     .cornerRadius(cornerRadius)
            case .failure:
                    ZStack {
                        Rectangle()
                            .frame(width: abs(UIScreen.main.bounds.width / divideScreenWidthBy), height: abs(UIScreen.main.bounds.height / divideScreenHeightBy))
                            .cornerRadius(cornerRadius)
                            .foregroundColor(.gray.opacity(0.75))
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.gray)
                    }
            default:
                ZStack {
                    Rectangle()
                        .frame(width: abs(UIScreen.main.bounds.width / divideScreenWidthBy), height: abs(UIScreen.main.bounds.height / divideScreenHeightBy))
                        .cornerRadius(cornerRadius)
                        .foregroundColor(.gray.opacity(0.75))
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct HeaderView: View {
    var headline: String
    var subheadline: String
    var body: some View {
        VStack {
            HStack {
                Text(headline)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding([.horizontal,.top])
            HStack {
                Text(subheadline)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.gray.opacity(0.5))
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}


struct OverallSettingsView<T:View>: View {
    //TODO: add support for other colors in HeaderView and Button
    var headline: String
    var subheadline: String
    var closeButtonTitle: String
    var closeAction: () -> Void
    @ViewBuilder var content: T
    var body: some View {
        VStack {
            HeaderView(headline: headline, subheadline: subheadline)
            content
            Button {
                closeAction()
            } label: {
                HStack {
                    Spacer()
                    Text(closeButtonTitle)
                    Spacer()
                }
                    .foregroundColor(Color("white"))
                    .padding()
                    .background(Color("black").cornerRadius(20))
                    .padding(.horizontal)
                    
            }
        }
    }
}
