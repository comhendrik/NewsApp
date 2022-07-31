//
//  SearchHistoryView.swift
//  NewsApp
//
//  Created by Hendrik Steen on 26.07.22.
//

import SwiftUI

struct SearchHistoryView: View {
    @Binding var searchPhrase: String
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Record.title, ascending: true)]) var records: FetchedResults<Record>
    @EnvironmentObject() var controller: PersistenceController
    @State private var refreshingID = UUID()
    var body: some View {
        List {
            HStack {
                Text("Search History")
                Spacer()
                Button {
                    controller.deleteAllRecords()
                    self.refreshingID = UUID()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                }
                .disabled(records.isEmpty)

            }
            ForEach(records.filter({"\($0.title ?? "unknown title")".contains(searchPhrase) || searchPhrase.isEmpty})) { record in
                Button {
                    searchPhrase = record.title ?? "unknown title"
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.right")
                            .foregroundColor(.gray)
                        Text(record.title ?? "unknown title for recent search")
                        Spacer()
                        Button {
                            controller.deleteItemWithObject(with: record)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.gray.opacity(0.75))
                        }
                    }
                }

            }
            .id(refreshingID)
            
            
        }
        .listStyle(.plain)
    }
}

