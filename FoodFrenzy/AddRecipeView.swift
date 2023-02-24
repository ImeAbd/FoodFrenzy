//
//  AddRecipeView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-01-31.
//


import SwiftUI
import Firebase
import FirebaseFirestore


struct AddRecipeView: View {
    @State private var name = ""
    @State private var category = ""
    @State private var prepTime = ""
    @State private var instructions = ""
    @State private var ingredients = [""]
    let userID = Auth.auth().currentUser?.uid
    let categories = ["Breakfast", "Lunch", "Dinner", "Salad", "Drink", "Dessert"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Name")) {
                    TextField("Enter the Recipe Name", text: $name)
                }
                Section(header: Text("Preparation Time")) {
                    TextField("Enter The Total Minutes", text: $prepTime)
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                }
                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                Section(header: Text("Ingredients")) {
                    ForEach(0 ..< ingredients.count, id: \.self) { index in
                        HStack {
                            TextField("Add Ingredient", text: self.$ingredients[index])
                            Button(action: {
                                self.ingredients.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    HStack {
                        Text("Add another Ingredient")
                        Button(action: {
                            self.ingredients.append("")
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
                Section(header: Text("Instructions")) {
                    TextEditor(text: $instructions)
                        .frame(height: 60)
                }
                Button(action: {
                    AddRecipeView().saveRecipeToFirebase(recipe: self, userID: userID ?? "")
                }) {
                    Text("Save Recipe")
                }
            }
            .navigationBarTitle("Add Recipe")
            .padding(.bottom)
        }
        
    }

    
    
    func saveRecipeToFirebase(recipe: AddRecipeView, userID: String) {
        let db = Firestore.firestore()
        let recipeRef = db.collection("recipes").document()
        let recipeID = recipeRef.documentID
        recipeRef.setData([
            "id": recipeID,
            "name": recipe.name,
            "category": recipe.category,
            "prepTime": recipe.prepTime,
            "instructions": recipe.instructions,
            "ingredients": recipe.ingredients,
            "userID": userID
        ]) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    struct AddRecipeView_Previews: PreviewProvider {
        static var previews: some View {
            AddRecipeView()
            
        }
    }
}
