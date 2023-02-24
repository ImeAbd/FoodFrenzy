//
//  PersonalProfileView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-08.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct Recipe: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var ingredients: [String]
    var instructions: String
    var userID: String
    var category: String
    var prepTime: Int
    
    init(id: UUID = UUID(), name: String, ingredients: [String], instructions: String, userID: String, category: String, prepTime: Int) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.userID = userID
        self.category = category
        self.prepTime = prepTime
    }

    
    init(dictionary: [String: Any]) {
        self.id = UUID(uuidString: dictionary["id"] as? String ?? "") ?? UUID()
        self.name = dictionary["name"] as? String ?? ""
        self.ingredients = dictionary["ingredients"] as? [String] ?? []
        self.instructions = dictionary["instructions"] as? String ?? ""
        self.userID = dictionary["userID"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.prepTime = dictionary["prepTime"] as? Int ?? 0
    }
}

    
    /*func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }*/

struct PersonalProfileView: View {
    @StateObject var viewModel = PersonalProfileViewModel()
    @EnvironmentObject var authenticationState: AuthenticationState
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if viewModel.recipes.isEmpty {
                    Text("No recipes found")
                } else {
                    List(viewModel.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRow(recipe: recipe)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchRecipes()
            }
            .onChange(of: viewModel.recipes) { _ in
                print("Recipes updated: \(viewModel.recipes)")
            }
            .navigationTitle("Personal Recipe Book")
            .navigationBarItems(trailing: Button("Log Out") {
                authenticationState.signOut()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}






struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.category)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(recipe.prepTime) mins")
                .foregroundColor(.gray)
        }
    }
}

class PersonalProfileViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    let loggedInUserID = Auth.auth().currentUser?.uid
    
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() {
        db.collection("recipes")
            .whereField("userID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching recipes: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No recipes found")
                    return
                }
                
                let recipes = documents.compactMap { document -> Recipe? in
                    let data = document.data()
                    return Recipe(dictionary: data)
                }
                
                DispatchQueue.main.async {
                    self.recipes = recipes
                }
                
                print("Fetched recipes: \(recipes)")
            }        
    }
}
struct PersonalProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalProfileView()
    }
}
