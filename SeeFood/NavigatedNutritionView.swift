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
            Text(nutritionData?.name?[1] ?? "no value found")
        }
        
    }
}

struct NavigatedNutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatedNutritionView(nutritionData: nil)
    }
}
