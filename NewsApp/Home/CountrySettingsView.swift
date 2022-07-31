//
//  SettingsView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 27.07.22.
//

import SwiftUI

struct CountrySettingsView: View {
    @AppStorage("country") var countryInt = 0
    @State private var showSelection = false
    var body: some View {
        Button {
            showSelection = true
        } label: {
            switch countryInt {
            case 1:
                Text("🇩🇪")
            case 2:
                Text("🇯🇵")
            case 3:
                Text("🇫🇷")
            case 4:
                Text("🇬🇧")
            default:
                Text("🇺🇸")
            }
        }
        .fullScreenCover(isPresented: $showSelection) {
            CountrySelectionView(countryInt: $countryInt, showSelection: $showSelection)
        }

    }
}

struct CountrySelectionView: View {
    @Binding var countryInt: Int
    @Binding var showSelection: Bool
    @EnvironmentObject private var apicaller: APICaller
    var body: some View {
        OverallSettingsView(headline: "Select your country", subheadline: "We do our best to extend the number of countrys.", closeButtonTitle: "Continue") {
            apicaller.currentCategory = .general
            apicaller.fetchArticlesByCategory()
            showSelection.toggle()
        } content: {
            ScrollView(showsIndicators: false) {
                ForEach(Country.allCases) { country in
                    Button {
                        countryInt = country.id
                        apicaller.articles = [[],[],[],[],[],[],[],[]]
                    } label: {
                        HStack {
                            Text("\(country.emojiValue) \(country.stringValue)")
                            .foregroundColor(country.id == countryInt ? Color("white") : Color("black"))
                            Spacer()
                        }
                        .padding()
                        .background(country.id == countryInt ? Color("black") : Color.clear)
                        .cornerRadius(20)
                        
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                }
            }
        }

    }
}
