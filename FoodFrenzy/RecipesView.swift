//
//  CategoryRecipeView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-19.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RecipesView: View {
    let category: String
    @State var recipes: [Recipe] = []
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    Text(recipe.name)
                }
            }
            .navigationTitle(category)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
            })
            .onAppear {
                loadRecipes()
            }
        }
    }
    
    func loadRecipes() {
        let db = Firestore.firestore()
        db.collection("recipes")
            .whereField("category", isEqualTo: category) // Only load recipes with the selected category
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting recipes: \(error)")
                    return
                }
                
                self.recipes = querySnapshot!.documents.compactMap { document in
                    let data = document.data()
                    print("Data dictionary: \(data)")
                    
                    let id = document.documentID
                    print("Recipe ID: \(id)")
                    
                    let name = data["name"] as? String ?? ""
                    print("Recipe name: \(name)")
                    
                    let category = data["category"] as? String ?? ""
                    print("Recipe category: \(category)")
                    
                    let prepTime = data["prepTime"] as? Int ?? 0
                    print("Recipe prep time: \(prepTime)")
                    
                    let instructions = data["instructions"] as? String ?? ""
                    let ingredients = data["ingredients"] as? [String] ?? []
                    
                    return Recipe(id: UUID(uuidString: id) ?? UUID(), name: name, ingredients: ingredients, instructions: instructions, userID: "", category: category, prepTime: prepTime)
                }
                
                print("Recipes: \(self.recipes)")
            }
    }
}



struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack {
            Text(recipe.name)
                .font(.title)
            Text("Prep time: \(recipe.prepTime) minutes")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Divider()
            Section(header: Text("Ingredients")) {
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }
            }
            Divider()
            Section(header: Text("Instructions")) {
                ScrollView {
                    Text(recipe.instructions)
                        .font(.body)
                        .padding()
                }
            }
        }
        .padding(.horizontal)
        .navigationBarTitle(Text(recipe.name), displayMode: .inline)

    }
}

/*struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}*/
