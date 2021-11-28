//
//  ContentView.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            HomeView(classifier: ImageClassifier()).tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            HistoryView().tabItem {
                Image(systemName: "clock.arrow.circlepath")
                Text("History")
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
