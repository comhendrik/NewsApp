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

//TODO: Case for all news
enum Category {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    
    var stringValue: String {
        switch self {
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .general:
            return "General"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        }
    }
    
    var queryValue: String {
        switch self {
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
        case .general:
            return "general"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .technology:
            return "technology"
        }
    }
}

extension Category: Identifiable {
    var id: Self { self }
}



@MainActor
class APICaller: ObservableObject {
    @Published var articles = [Article]()
    @Published var currentCategory: Category = .business
    
    let countryForFetching = "de"
    let apiKey = "Key"
    
    init() {
        Task {
            //fetch articles for first category automatically because otherwise there wouldn't be articles after launching the app
           // await fetchArticles(category: currentCategory.queryValue, country: countryForFetching)
            
            
            //test objects because you don't want to query all the times while development
            for i in 0 ..< 10 {
                fetchArticlesForTesting(idNumber: i)
            }
        }
    }
    
    
    //TODO: Proper error handling for full function
    //API Call for articles
    func fetchArticles(category: String, country: String) async {
        
        var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
        
        //create queryItems from passed values
        
        let category = URLQueryItem(name: "category", value: category)
        let country = URLQueryItem(name: "country", value: country)
        let key = URLQueryItem(name: "apiKey", value: apiKey)
        
        topHeadLinesUrl?.queryItems?.append(country)
        topHeadLinesUrl?.queryItems?.append(category)
        topHeadLinesUrl?.queryItems?.append(key)
        
        
        //check if url is valid
        guard let urlForFetching = topHeadLinesUrl?.url else {
            print("error")
            return
        }

        //get data from api
        do {
            articles = []
            let (data, _) = try await URLSession.shared.data(from: urlForFetching)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            articles = decodedData.articles
        } catch {
            print(error)
        }
        
    }
    
    func fetchArticlesForTesting(idNumber: Int) {
        articles.append(Article(source: Source(id: nil, name: "New York Post"), author: "Patrick Reilly", title: "Google fires software engineer who claimed AI bot was 'sentient' - New York Post ", description: "Blake Lemoine, who works in Google’s Responsible AI organization, was placed on administrative leave last month after he said the AI chatbot known as LaMDA claims to have a soul.", id: "https://nypost.com/2022/07/23/google-fires-software-engineer-blake-lemoine-who-claimed-ai-bot-was-sentient/\(idNumber)", urlToImage: "https://nypost.com/wp-content/uploads/sites/2/2022/07/newspress-collage-23171904-1658554567135.jpg?quality=75&strip=all&1658540595&w=1024", publishedAt: "2022-07-23T06:37:00Z", content: "Google has fired a senior software engineer who claimed that the company had developed a sentient artificial intelligence bot, the company announced Friday.\r\nBlake Lemoine, who worked in Googles Resp… [+2377 chars]"))
        articles.append(Article(source: Source(id: nil, name: "Investor's Business Daily"), author: "Investor's Business Daily", title: "Market Rally Faces Earnings Wave, Big Fed Rate Hike; What To Do - Investor's Business Daily", description: "Several stocks flashing buy signals have had quick sell-offs, forcing tough decisions.", id: "https://www.investors.com/market-trend/stock-market-today/dow-jones-futures-apple-earnings-fed-rate-hike-headline-huge-market-week-what-to-do-now/\(idNumber)", urlToImage: "https://www.investors.com/wp-content/uploads/2020/04/Stock-BigWavePipe-08-adobe.jpg", publishedAt: "2022-07-22T22:41:00Z", content: "Dow Jones futures will open on Sunday evening, along with S&amp;P 500 futures and Nasdaq futures. The stock market rally had strong gains last week, breaking above some key resistance. Techs pulled b… [+7977 chars]"))
    }
}

