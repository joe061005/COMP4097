//
//  HomeView.swift
//  SeeFood
//
//  Created by xdeveloper on 26/11/2021.
//

import SwiftUI

struct HomeView: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    //used to create core data objects
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var classifier: ImageClassifier
    
    @State var food: Food = Food(items: [])
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "photo")
                    .onTapGesture {
                        isPresenting = true
                        sourceType = .photoLibrary
                    }
                
                Image(systemName: "camera")
                    .onTapGesture {
                        isPresenting = true
                        sourceType = .camera
                    }
            }
            .font(.title)
            .foregroundColor(.blue)
            
            Rectangle()
                .strokeBorder()
                .foregroundColor(.yellow)
                .overlay(
                    Group {
                        VStack{
                            if uiImage != nil {
                                Image(uiImage: uiImage!)
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                )
            
            VStack{
                if(!food.items.isEmpty){
                    List(food.items){
                        nut in
                        VStack(alignment: .leading){
                            Group{
                                Text("Detected: \(nut.name)")
                                Text("Sugar: \(nut.sugar_g, specifier: "%.1f") g")
                                Text("Fiber: \(nut.fiber_g, specifier: "%.1f") g")
                                Text("Carbohydrates: \(nut.carbohydrates_total_g, specifier: "%.1f") g")
                                Text("Serving size: \(nut.serving_size_g, specifier: "%.1f") g")
                                Text("Sodium: \(nut.sodium_mg, specifier: "%.1f") mg")
                            }
                            
                            Group{
                                Text("Potassium: \(nut.potassium_mg, specifier: "%.1f") mg")
                                Text("Saturated Fat: \(nut.fat_saturated_g, specifier: "%.1f") g")
                                Text("Total Fat: \(nut.fat_total_g, specifier: "%.1f") g")
                                Text("Calories: \(nut.calories, specifier: "%.1f") cal")
                                Text("Cholesterol: \(nut.cholesterol_mg, specifier: "%.1f") mg")
                                Text("Protein: \(nut.protein_g, specifier: "%.1f") g")
                            }
                            
                        }
                        
                        
                        
                    }
                    
                    Button(action: {
                        startSave(food: food)
                    }) {
                        Text("Save")
                    }.disabled(food.items.isEmpty)
                }
            }
            
            
            
            VStack{
                Button(action: {
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                    }
                }) {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.orange)
                        .font(.title)
                }
                
                
                Group {
                    if let imageClass = classifier.imageClass {
                        HStack{
                            Text("Image categories:")
                                .font(.caption)
                            Text(imageClass)
                                .bold()
                        }
                    } else {
                        HStack{
                            Text("Image categories: NA")
                                .font(.caption)
                        }
                    }
                }
                .font(.subheadline)
                .padding()
                
            }
        }
        
        .sheet(isPresented: $isPresenting){
            ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                .onDisappear{
                    if uiImage != nil {
                        classifier.detect(uiImage: uiImage!)
                        classifier.calorieNinja(){
                            food = classifier.food!
                            print("Food ", food)
                        }
                        //                        classifier.getNutritionInfo(){
                        //                            food = classifier.food!
                        //                        }
                    }
                }
            
        }.padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(classifier: ImageClassifier())
    }
}

extension HomeView{
    func getDate()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    func getStringDate()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .long
        timeFormatter.timeStyle = .short
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    func startSave(food: Food) {
        let foodObj = FoodData(context: managedObjectContext)
        
        let data = uiImage!.jpegData(compressionQuality: 1.0)
        
        //instantiate object arrays
        foodObj.calories = [Double]()
        foodObj.carbohydrates_total_g = [Double]()
        foodObj.cholestrol_mg = [Int64]()
        foodObj.fat_saturated_g = [Double]()
        foodObj.fat_total_g = [Double]()
        foodObj.fiber_g = [Double]()
        foodObj.name = [String]()
        foodObj.potassium_mg = [Int64]()
        foodObj.protein_g = [Double]()
        foodObj.serving_size_g = [Double]()
        foodObj.sodium_mg = [Int64]()
        foodObj.sugar_g = [Double]()
        
        //append arrays
        food.items.forEach { nutrition in
            foodObj.calories?.append(nutrition.calories)
            foodObj.carbohydrates_total_g?.append(nutrition.carbohydrates_total_g)
            foodObj.cholestrol_mg?.append(Int64(nutrition.cholesterol_mg))
            foodObj.fat_saturated_g?.append(nutrition.fat_saturated_g)
            foodObj.fat_total_g?.append(nutrition.fat_total_g)
            foodObj.fiber_g?.append(nutrition.fiber_g)
            
            foodObj.name?.append(nutrition.name)
            
            foodObj.potassium_mg?.append(Int64(nutrition.potassium_mg))
            foodObj.protein_g?.append(nutrition.protein_g)
            foodObj.serving_size_g?.append(nutrition.serving_size_g)
            foodObj.sodium_mg?.append(Int64(nutrition.sodium_mg))
            foodObj.sugar_g?.append(nutrition.sugar_g)
        }
        foodObj.timestamp = getDate()
        foodObj.imgClass = classifier.imageClass
        foodObj.img_data = data
        foodObj.saved = true

        
        do {
            try managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
    }
    
    func clearData() {
        uiImage = nil
        food = Food(items:[])
    }
    
}
