//
//  Persistence.swift
//  SeeFood
//
//  Created by xdeveloper on 28/11/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //provide previews example object here
        for _ in 0..<5 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
            let foodItem = FoodData(context: viewContext)
            let randomIntArr = (0..<3).map{_ in Int64.random(in: 1...10)}
            let randomDoubleArr = (0..<3).map{_ in Double.random(in: 1...10)}
            
            foodItem.calories = randomDoubleArr
            foodItem.carbohydrates_total_g = randomDoubleArr
            foodItem.cholestrol_mg = randomIntArr
            foodItem.fat_saturated_g = randomDoubleArr
            foodItem.fat_total_g = randomDoubleArr
            foodItem.fiber_g = randomDoubleArr
            
            foodItem.potassium_mg = randomIntArr
            foodItem.protein_g = randomDoubleArr
            foodItem.serving_size_g = randomDoubleArr
            foodItem.sodium_mg = randomIntArr
            foodItem.sugar_g = randomDoubleArr
            
            foodItem.name = ["random placeholder1", "random placeholder2", "random placeholder3"]
            foodItem.timestamp = "placeholder timestamp"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name:"FoodNutrition")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
