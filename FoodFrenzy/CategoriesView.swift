//
//  CategoriesView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-02-08.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Category: Identifiable {
    var id = UUID()
    var name: String
}

struct CategoriesView: View {
    @State var categories: [Category] = []
    
    var body: some View {
        NavigationView {
            List(categories) { category in
                NavigationLink(destination: RecipesView(category: category.name)
                                    .navigationBarHidden(true)) {
                                        //  remove any extra padding or gap caused by the navigation bar in the RecipesView.
                    VStack {
                        Text(category.name)
                            .foregroundColor(.white)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 85)
                    .background(Color.orange)
                    .padding(.horizontal, 1)
                    .cornerRadius(20)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Categories")
            .onAppear {
                loadCategories()
            }
          //  .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
        
        
        
        
        func loadCategories() {
            let db = Firestore.firestore()
            db.collection("recipes").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting categories: \(error)")
                    return
                }
                var categorySet = Set<String>()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let category = data["category"] as? String ?? ""
                    categorySet.insert(category)
                }
                self.categories = Array(categorySet).map { Category(name: $0) }
            }
        }
    }

    struct CategoriesView_Previews: PreviewProvider {
        static var previews: some View {
            CategoriesView()
        }
    }
