//
//  SeeFoodApp.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import SwiftUI

@main
struct SeeFoodApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
