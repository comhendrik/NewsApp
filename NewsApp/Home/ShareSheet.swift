//
//  ShareSheet.swift
//  NewsApp
//
//  Created by Hendrik Steen on 31.07.22.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {

    }
}

struct ShareSheet: View {
    let article: Article
    @State private var showingSheet = false

    var body: some View {
        Button(action: {
            self.showingSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(Color("white"))
        }
        .sheet(isPresented: $showingSheet,
               content: {
            ActivityView(activityItems: [URL(string: article.id ?? "no url") ?? URL(string: "https://apple.com")!] as [Any], applicationActivities: nil) })
    }
}

