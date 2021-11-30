//
//  NavigatedNutritionView.swift
//  SeeFood
//
//  Created by xdeveloper on 30/11/2021.
//

import SwiftUI

struct NavigatedNutritionView: View {
    var nutritionData: FoodData?
    
    var body: some View {
        VStack{
            Text(nutritionData?.timestamp ?? "no value found")
            ForEach(0 ..< (nutritionData?.name?.count)!) { value in
                Group{
                    Text("Detected: \(nutritionData?.name?[value] ?? "no value found")")
                    Text("Sugar: \(nutritionData?.sugar_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Fiber: \(nutritionData?.fiber_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Carbohydrates: \(nutritionData?.carbohydrates_total_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Serving size: \(nutritionData?.serving_size_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Sodium: \(nutritionData?.sodium_mg?[value] ?? -1, specifier: "%.1f") mg")
                }
                
                Group{
                    Text("Potassium: \(nutritionData?.potassium_mg?[value] ?? -1, specifier: "%.1f") mg")
                    Text("Saturated Fat: \(nutritionData?.fat_saturated_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Total Fat: \(nutritionData?.fat_total_g?[value] ?? -1, specifier: "%.1f") g")
                    Text("Calories: \(nutritionData?.calories?[value] ?? -1, specifier: "%.1f") cal")
                    Text("Cholesterol: \(nutritionData?.cholestrol_mg?[value] ?? -1, specifier: "%.1f") mg")
                    Text("Protein: \(nutritionData?.protein_g?[value] ?? -1, specifier: "%.1f") g")
                }
            }
            
        }
        
    }
}

//struct NavigatedNutritionView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigatedNutritionView(nutritionData: nil)
//    }
//}
