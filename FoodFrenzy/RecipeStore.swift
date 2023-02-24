//
//  RecipeStore.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-21.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeStore: ObservableObject {
    @Published var recipes = [Recipe]()
    
    func fetchRecipes(for userId: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("recipes").whereField("userId", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion()
                return
            }
            
            guard let snapshot = snapshot else {
                print("Error retrieving snapshot")
                completion()
                return
            }
            
            let recipes = snapshot.documents.compactMap { document -> Recipe? in
                try? document.data(as: Recipe.self)
            }
            
            DispatchQueue.main.async {
                self.recipes = recipes
                completion()
            }
        }
    }
}

