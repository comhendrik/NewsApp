//
//  Persistence.swift
//  NewsApp
//
//  Created by Hendrik Steen on 26.07.22.
//

import CoreData
import SwiftUI

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Searchhistory")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveSearchHistoryRecord(with term: String) {
        let record = Record(context: container.viewContext)
        record.title = term
        saveContext()
    }
    
    func deleteItemsWithIndexSet(at offsets: IndexSet, items: FetchedResults<Record>) {
        for index in offsets {
            let item = items[index]
            container.viewContext.delete(item)
        }
        
        saveContext()
    }
    
    func deleteItemWithObject(with record: Record) {
        container.viewContext.delete(record)
        saveContext()
    }
    
    func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("error")
        }
    }
}
