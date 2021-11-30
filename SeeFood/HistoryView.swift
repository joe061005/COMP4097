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
    
    //used to create core data objects
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init() {
        self._results = FetchRequest(
            entity: FoodData.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FoodData.timestamp, ascending: true)]
        )
    }
    
    var body: some View {
        NavigationView{
            List(results) { resultItem in
                NavigationLink(destination: NavigatedNutritionView(nutritionData: resultItem)){
                    HStack{
                        Spacer()
                        Text("\(resultItem.name?[0] ?? "No value provided")")
                        Spacer()
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
