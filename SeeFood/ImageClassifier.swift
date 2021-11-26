//
//  ImageClassification.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
    
    var food: Food?
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
    
    func getNutritionInfo(callback:@escaping () -> Void){
        guard let endcodeUrlString = imageClass?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else {
            return
        }
        
        print(endcodeUrlString)
        
        guard let url = URL(string: "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(endcodeUrlString)&pageSize=2&api_key=bMwH9mJTka9Z1ejenjTCbMRPzhh2faflXJvczIeb")
        else{
            print("Invalid url string")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if let error = error{
                print(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print(response)
                      return
                  }
            
            print("ok")
            
            if let data = data, let food = try?
                JSONDecoder().decode(Food.self, from: data){
                self.food = food
                print(self.food)
            }
            callback()

            
        }
        task.resume()
    }
    
    func calorieNinja(){
        guard let endcodeUrlString = imageClass?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)else {
            return
        }
        
        guard let url = URL(string: "https://api.calorieninjas.com/v1/nutrition?query=\(endcodeUrlString)")
        else{
            print("Invalid url string")
            return
        }
        
        //set API Key here
        var request = URLRequest(url: url)
        request.setValue("x7CglOn0K3KJaLmGdv/q1g==ikn1hLHMSGCng7sy", forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}

struct Food: Decodable, Identifiable{
    let id = UUID()
    let foods: [nutrition]
}

struct nutrition: Decodable, Identifiable{
    let id = UUID()
    let foodNutrients: [info]
}

struct info: Decodable, Identifiable{
    let id = UUID()
    let nutrientName: String
    let unitName: String
    let nutrientNumber: String
}

//struct Food: Decodable, Identifiable{
//    let id = UUID()
//    let items: [nutrition]
//}
//
//struct nutrition: Decodable, Identifiable{
//    let id = UUID()
//    let sugar_g: Double
//    let fiber_g: Double
//    let serving_size_g: Double
//    let sodium_mg: Int
//    let name: String
//    let potassium_mg: Int
//    let fat_saturated_g: Double
//    let fat_total_g: Double
//    let calories: Double
//    let cholestrol_mg: Double
//    let proteim_g: Double
//    let carbohydrates_total_g: Double
//}

