//
//  FoodFrenzyApp.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-01-30.
//

import SwiftUI
import Firebase

@main
struct FoodFrenzyApp: App {
    let recipeStore = RecipeStore()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeStore)
        }
    }
}
