//
//  HistoryView.swift
//  SeeFood
//
//  Created by xdeveloper on 26/11/2021.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @FetchRequest var results: FetchedResults<FoodData>
    var saved = false
    
    //used to create core data objects
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init() {
        self._results = FetchRequest(
            entity: FoodData.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FoodData.timestamp, ascending: true)],
            predicate: NSPredicate(format: "saved == true")
        )
    }
    
    var body: some View {
        NavigationView{
            List(results.filter { $0.saved == true }) { resultItem in
                NavigationLink(destination: NavigatedNutritionView(nutritionData: resultItem)){
                    HStack{
                        //instead of only text, we can also show a small pic of image as well
                        Spacer()
                        Text("\(resultItem.name?[0] ?? "No value provided")")
                        Spacer()
                    }
                }
                Button("Delete") {
                    managedObjectContext.performAndWait {
                        resultItem.saved = false
                        try? managedObjectContext.save()
                    }
                }
            }
            .navigationBarTitle("History", displayMode: .inline).navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
