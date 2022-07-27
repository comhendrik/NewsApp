//
//  CustomTypes.swift
//  NewsApp
//
//  Created by Hendrik Steen on 27.07.22.
//

import Foundation


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


enum Category: Codable {
    case search
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
    
    var stringValue: String {
        switch self {
        case .search:
            return "Search"
        case .general:
            return "General"
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
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
        case .search:
            return "q"
        case .general:
            return "general"
        case .business:
            return "business"
        case .entertainment:
            return "entertainment"
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
    
    var emojiValue: String {
        switch self {
        case .search:
            return "🕵️‍♂️"
        case .general:
            return "📰"
        case .business:
            return "📊"
        case .entertainment:
            return "🎮"
        case .health:
            return "💊"
        case .science:
            return "🧬"
        case .sports:
            return "💪"
        case .technology:
            return "💻"
        }
    }
    
    var arrayIndex: Int {
        switch self {
        case .search:
            return 0
        case .general:
            return 1
        case .business:
            return 2
        case .entertainment:
            return 3
        case .health:
            return 4
        case .science:
            return 5
        case .sports:
            return 6
        case .technology:
            return 7
        }
    }
}

extension Category: Identifiable {
    var id: Self { self }
}


//[Category] needs to be saved in @AppStorage to make it possible to save the users decision which categorys he wants te see
typealias CategoryArray = [Category]

extension CategoryArray: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([Category].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        
        return result
    }
}

enum Country: CaseIterable, Identifiable {
    
    case usa, germany, japan, france, uk
    
    
    var countryCode: String {
        switch self {
        case .usa:
            return "us"
        case .germany:
            return "de"
        case .japan:
            return "jp"
        case .france:
            return "fr"
        case .uk:
            return "gb"
        }
    }
    
    var stringValue: String {
        switch self {
        case .usa:
            return "USA"
        case .germany:
            return "Germany"
        case .japan:
            return "Japan"
        case .france:
            return "France"
        case .uk:
            return "United Kingdom"
        }
    }
    
    var emojiValue: String {
        switch self {
        case .usa:
            return "🇺🇸"
        case .germany:
            return "🇩🇪"
        case .japan:
            return "🇯🇵"
        case .france:
            return "🇫🇷"
        case .uk:
            return "🇬🇧"
        }
    }
    
    var id: Int {
        switch self {
        case .usa:
            return 0
        case .germany:
            return 1
        case .japan:
            return 2
        case .france:
            return 3
        case .uk:
            return 4
        }
    }
    
    
}
