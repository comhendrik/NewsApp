//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Hendrik Steen on 22.07.22.
//

import SwiftUI

@main
struct NewsAppApp: App {
    
    let apicaller = APICaller()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apicaller)
        }
    }
}
