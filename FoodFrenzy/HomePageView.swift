//
//  HomePageView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-08.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct HomePageView: View {
    @StateObject var authenticationState = AuthenticationState()
    @State var recipes: [Recipe] = []
    let db = Firestore.firestore()
    @State private var searchText = ""
    
    var body: some View {
        TabView {
            RecipeListView(recipes: recipes, searchText: $searchText)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
            
            AddRecipeView()
                .tabItem {
                    Label("Add Recipe", systemImage: "plus.square")
                }
            
            PersonalProfileView()
                .environmentObject(authenticationState)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .onAppear {
            db.collection("recipes").addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let snapshot = snapshot {
                    for change in snapshot.documentChanges {
                        if change.type == .added {
                            let data = change.document.data()
                            let recipe = Recipe(
                                id: UUID(uuidString: data["id"] as? String ?? "") ?? UUID(),
                                name: data["name"] as? String ?? "",
                                ingredients: data["ingredients"] as? [String] ?? [],
                                instructions: data ["instructions"] as? String ?? "",
                                userID: data["userID"] as? String ?? "",
                                category: data ["category"] as? String ?? "",
                                prepTime: data["prepTime"] as? Int ?? 0
                            )
                            self.recipes.append(recipe)
                        }
                    }
                }
            }
        }
    }
    
    struct RecipeListView: View {
        let recipes: [Recipe]
        @Binding var searchText: String
        
        var body: some View {
            NavigationView {
                VStack {
                    SearchBar(text: $searchText)
                        .padding(.top)
                    
                    List {
                        ForEach(recipes.filter {
                            self.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.searchText)
                        }, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                Text(recipe.name)
                            }
                        }
                    }
                }
                .navigationTitle("Recipes")
            }
        }
    }
}



struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
}

   

    
    struct HomePageView_Previews: PreviewProvider {
        static var previews: some View {
            HomePageView()
        }
    }
