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
            CountrySelectionsView(countryInt: $countryInt, showSelection: $showSelection)
        }

    }
}

struct CountrySelectionsView: View {
    @Binding var countryInt: Int
    @Binding var showSelection: Bool
    @EnvironmentObject private var apicaller: APICaller
    var body: some View {
        VStack {
            HeaderView(headline: "Select your country", subheadline: "We do our best to extend the number of countrys.")
                .padding()
            ScrollView(showsIndicators: false) {
                ForEach(Country.allCases) { country in
                    Button {
                        countryInt = country.id
                        apicaller.articles = [[],[],[],[],[],[],[],[]]
                    } label: {
                        HStack {
                            Text("\(country.emojiValue) \(country.stringValue)")
                            .foregroundColor(country.id == countryInt ? .white : .black)
                            Spacer()
                        }
                        .padding()
                        .background(country.id == countryInt ? Color.black : Color.clear)
                        .cornerRadius(20)
                        
                    }
                    .padding(.horizontal)
                    .listRowSeparator(.hidden)
                }
                
                Button {
                    Task { @MainActor in
                        apicaller.currentCategory = .general
                        apicaller.articles[apicaller.currentCategory.arrayIndex] = await apicaller.fetchArticlesByCategory(category: apicaller.currentCategory.queryValue)
                        showSelection.toggle()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Continue")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(20)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}
