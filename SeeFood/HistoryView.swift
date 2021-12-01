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
                let coredataLoadedimage = UIImage(data: (resultItem.img_data)!)
                let date = String(resultItem.timestamp ?? "")
                HStack{
                    NavigationLink(destination: NavigatedNutritionView(nutritionData: resultItem)){
                        Image(uiImage: coredataLoadedimage!)
                            .resizable()
                            .scaledToFit()
                            .frame(height:80)
                        Text(getDate(time: date ))
                        Text("\(resultItem.name?[0] ?? "No value provided")")
                        if ((resultItem.name!.count) > 1) {
                            Text("\(resultItem.name?[1] ?? "")")
                        }
                    }
                    Button("X") {
                        managedObjectContext.performAndWait {
                            resultItem.saved = false
                            try? managedObjectContext.save()
                        }
                    }.buttonStyle(.borderless).foregroundColor(.red)

                }
            }
            .navigationBarTitle("History", displayMode: .inline).navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

func getDate(time:String)->String{
    let timeFormatter = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "HH:mm E, d MMM y"
    timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let newDate = timeFormatter.date(from: time)!
    let dates = dateFormatterPrint.string(from: newDate)
    return dates
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
