//
//  EditRecipeView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-22.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct EditRecipeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: EditRecipeViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Information")) {
                    TextField("Name", text: $viewModel.recipeName)
                    TextField("Category", text: $viewModel.recipeCategory)
                    TextField("Preparation Time (minutes)", value: $viewModel.recipePrepTime, formatter: NumberFormatter())
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(viewModel.ingredients.indices, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $viewModel.ingredients[index])
                    }
                    Button(action: {
                        viewModel.addIngredient()
                    }, label: {
                        Label("Add Ingredient", systemImage: "plus")
                    })
                }
                
                Section(header: Text("Instructions")) {
                    TextEditor(text: $viewModel.recipeInstructions)
                        .frame(minHeight: 200)
                }
                
                Section {
                    Button(action: {
                        viewModel.updateRecipe()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Update Recipe")
                    })
                }
            }
            .navigationTitle("Edit Recipe")
        }
    }
}

class EditRecipeViewModel: ObservableObject {
    let db = Firestore.firestore()
    var recipe: Recipe
    
    @Published var recipeName: String
    @Published var recipeCategory: String
    @Published var recipePrepTime: Int
    @Published var ingredients: [String]
    @Published var recipeInstructions: String
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self._recipeName = .init(initialValue: recipe.name)
        self._recipeCategory = .init(initialValue: recipe.category)
        self._recipePrepTime = .init(initialValue: recipe.prepTime)
        self._ingredients = .init(initialValue: recipe.ingredients)
        self._recipeInstructions = .init(initialValue: recipe.instructions)
    }
    
    func addIngredient() {
        ingredients.append("")
    }
    
    func updateRecipe() {
        db.collection("recipes").document(recipe.id.uuidString).updateData([
            "name": recipeName,
            "category": recipeCategory,
            "prepTime": recipePrepTime,
            "ingredients": ingredients,
            "instructions": recipeInstructions
        ]) { error in
            if let error = error {
                print("Error updating recipe: \(error.localizedDescription)")
            } else {
                print("Recipe updated successfully")
            }
        }
    }
}


/*struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRecipeView(viewModel: EditRecipeViewModel(recipe: Recipe()))
    }
}*/
