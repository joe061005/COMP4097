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
                        VStack{
                        Text("Sugar: \(nut.sugar_g)")
                        Text("Fiber: \(nut.fiber_g)")
                        Text("Serving size: \(nut.serving_size_g)")
                        Text("Sodium: \(nut.sodium_mg)")
                        Text("Potassium: \(nut.potassium_mg)")
                        Text("Saturated Fat: \(nut.fat_saturated_g)")
                        Text("Total Fat: \(nut.fat_total_g)")
                        Text("Calories: \(nut.calories)")
                        Text("Cholesterol: \(nut.cholesterol_mg)")
                        Text("Protein: \(nut.protein_g)")
                        }
                        
                        
                      
                    }
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
    
}
