//
//  APICaller.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//


//The data is fetched from the news api (https://newsapi.org) and I use the top business headlines in Germany.

import Foundation
import SwiftUI

struct Article: Identifiable, Codable {
    var source: Source
    var author: String?
    var title: String?
    var description: String?
    var id: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case source = "source"
        case author = "author"
        case title = "title"
        case description = "description"
        case id = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"
    }
}

struct Source: Codable {
    var id: String?
    var name: String?
}

struct APIResponse: Codable {
    let articles: [Article]
    let totalResults: Int
    let status: String
}



@MainActor
class APICaller: ObservableObject {
    @Published var articles = [Article]()
    
    let apiKey = "Key"
    
    let urlToAPI = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey="
    
    
    //TODO: Proper error handling for full function
    //API Call for articles
    func fetchArticles() async {
        
        //check if url is valid
        guard let urlForFetching = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=Key") else {
            print("error")
            return
        }
        
        //get data from api
        do {
            let (data, _) = try await URLSession.shared.data(from: urlForFetching)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            articles = decodedData.articles
        } catch {
            print(error)
        }
        
    }
}

