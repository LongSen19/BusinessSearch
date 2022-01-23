//
//  BusinessesSearchApp.swift
//  BusinessesSearch
//
//  Created by Long Sen on 12/30/21.
//

import SwiftUI

@main
struct BusinessesSearchApp: App {
//    let persistenceController = PersistenceController.shared
    @StateObject var businessesSearch = BusinessesSearch()

    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(businessesSearch)
        }
    }
}
