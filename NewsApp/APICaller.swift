//
//  APICaller.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//


//The data is fetched from the news api (https://newsapi.org) and I use the top business headlines in Germany.


import Foundation
import SwiftUI

class APICaller: ObservableObject {
    @Published var articles: [[Article]] = [[],[],[],[],[],[],[],[]]
    @Published var currentCategory: Category = .general
    @AppStorage("country") var countryInt = 0
    let apiKey = "YOURAPIKEY"
    
    @AppStorage("categorys") var usedCategorys = CategoryArray()
    
    init() {
        Task { @MainActor in
            
            if !usedCategorys.contains(.general) {
                usedCategorys.append(.general)
            }
            
            //fetch articles for first category automatically because otherwise there wouldn't be articles after launching the app
            articles[currentCategory.arrayIndex] = await fetchArticlesByCategory(category: currentCategory.queryValue)
            
//           //test objects because you don't want to query all the times while development thats because the real function above is not called
//            for i in 0 ..< 10 {
//                fetchArticlesForTesting(index: i)
//            }
            
        }
    }
    
    
    //TODO: Proper error handling for full function
    //API Call for articles
    func fetchArticlesByCategory(category: String) async -> [Article] {
        
        var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/top-headlines?")
        
        //check country for query
        
        var countryForFetching: Country = .usa
        
        switch countryInt {
        case 1:
            countryForFetching = .germany
        case 2:
            countryForFetching = .japan
        case 3:
            countryForFetching = .france
        case 4:
            countryForFetching = .uk
        default:
            countryForFetching = .usa
        }
        
        //create queryItems from passed values
        
        let category = URLQueryItem(name: "category", value: category)
        let country = URLQueryItem(name: "country", value: countryForFetching.countryCode)
        let key = URLQueryItem(name: "apiKey", value: apiKey)
        
        
        
        topHeadLinesUrl?.queryItems?.append(country)
        topHeadLinesUrl?.queryItems?.append(category)
        topHeadLinesUrl?.queryItems?.append(key)
        
        
        //check if url is valid
        guard let urlForFetching = topHeadLinesUrl?.url else {
            print("guard error")
            return []
        }

        //get data from api
        do {
            let (data, _) = try await URLSession.shared.data(from: urlForFetching)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            return decodedData.articles
        } catch {
            print(error)
            return []
        }
        
    }
    
    func fetchArticlesBySearchPhrase(searchPhrase: String) async {
        var topHeadLinesUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
        
        //create queryItems from passed values
        
        let category = URLQueryItem(name: "q", value: searchPhrase)
        let key = URLQueryItem(name: "apiKey", value: apiKey)
        
        topHeadLinesUrl?.queryItems?.append(category)
        topHeadLinesUrl?.queryItems?.append(key)
        
        
        //check if url is valid
        guard let urlForFetching = topHeadLinesUrl?.url else {
            print("error")
            return
        }
        print(urlForFetching)

        //get data from api
        do {
            let (data, _) = try await URLSession.shared.data(from: urlForFetching)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            Task { @MainActor in
                articles[0] = decodedData.articles
            }
        } catch {
            print(error)
        }
    }
    
    func fetchArticlesForTesting(index: Int) {
        for i in 0 ..< articles.count {
            articles[i].append(
                Article(source: Source(id: "engadget", name: "Engadget"),
                        author: "Kris Holt",
                        title: "NBA 2K23's $150 Championship Edition includes a year of NBA League Pass",
                        description: "NBA 2K23 will arrive on September 9th, and it comes with a solid perk for those who plump for the premium $150 Championship Edition. Among other things, the package includes a year of access to NBA League Pass. If you're an avid NBA viewer who plays each year…",
                        id: "https://www.engadget.com/nba-2k23-michael-jordan-league-pass-2k-sports-140059388.html/\(index)",
                        urlToImage: "https://s.yimg.com/os/creatr-uploaded-images/2022-07/c6208340-fc9c-11ec-bffe-c1cbb070552b",
                        publishedAt: "2022-07-07T14:00:59Z",
                        content: "NBA 2K23 will arrive on September 9th, and it comes with a solid perk for those who plump for the premium $150 Championship Edition. Among other things, the package includes a year of access to NBA L… [+1863 chars]"))
            articles[i].append(
                Article(source: Source(id: "the-verge", name: "The Verge"),
                        author: "Richard Lawler",
                        title: "Twitter sues Elon Musk for attempting to abandon $44 billion acquisition",
                        description: "Elon Musk accused Twitter of breaching their deal, but now the company has filed a lawsuit against its richest user. Twitter claims Musk is the one who breached the deal, as their beef over bots heads into a Delaware courthouse.",
                        id: "https://www.theverge.com/2022/7/12/23205624/twitter-sues-elon-musk-acquisition-agreement/\(index)",
                        urlToImage: "https://cdn.vox-cdn.com/thumbor/HXkOVDBmMUp8DCkM1tk0V6jwhL4=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23382327/VRG_Illo_STK022_K_Radtke_Musk_Twitter_Upside_Down.jpg",
                        publishedAt: "2022-07-12T21:10:30Z",
                        content: "Elon Musk wants out of their acquisition agreement, but Twitter isnt ready to let go\r\nIllustration by Kristen Radtke / The Verge; Getty Images\r\nTwitter vs. Elon Musk is moving into the courts. The so… [+1070 chars]"))
            articles[i].append(
                Article(source: Source(id: "nil", name: "MacRumors"),
                        author: "Joe Rossignol",
                        title: "iPhone 14 Production to Begin Soon as Foxconn Begins Annual Hiring Spree",
                        description: "oxconn has commenced its annual seasonal hiring spree in preparation for iPhone 14 production, according to the South China Morning Post. The report claims that Foxconn is offering a 9,000 yuan bonus (around $1,300) to new assembly line workers who sta…",
                        id: "https://www.macrumors.com/2022/06/28/iphone-14-foxconn-hiring-spree/\(index)",
                        urlToImage: "https://images.macrumors.com/t/tilAlZOnMmX952oWadcfWWFx3-g=/2250x/article-new/2022/05/Beyond-iPhone-13-Feature-2.jpg",
                        publishedAt: "2022-06-28T14:17:19Z",
                        content: "Foxconn has commenced its annual seasonal hiring spree in preparation for iPhone 14 production, according to the South China Morning Post. \r\nThe report claims that Foxconn is offering a 9,000 yuan bo… [+1216 chars]"))
        }
    }
}

