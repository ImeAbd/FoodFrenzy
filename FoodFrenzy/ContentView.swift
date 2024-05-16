//
//  ContentView.swift
//  FoodFrenzy
//
//  Created by Imran Abdurrauf on 2023-01-30.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var showAlert = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""

    
    var body: some View {
        if userIsLoggedIn {
           HomePageView()
        } else {
            content.alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

           
    //
    var content: some View {
        ZStack {
            Color.orange
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack(spacing: 20) {
                Text("FoodFrenzy")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -70, y: -70)
                
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Enter Email")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Enter Password")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button {
                    login()
                } label: {
                    Text("Login")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                    

                }
                .padding(.top)
                .offset(y: 110)
                
            }
            .frame(width: 350)
            .onAppear {
                userIsLoggedIn = false
                }
                /*Auth.auth().addStateDidChangeListener {auth, user in
                    if user != nil{
                        userIsLoggedIn.toggle()
                    }
                }
            }*/
        }
            .ignoresSafeArea()
    }
    
    func login() {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    alertTitle = "Log In Unsuccessful"
                    alertMessage = error.localizedDescription
                } else {
                    userIsLoggedIn = true
                    alertTitle = "Log In Successful"
                    alertMessage = "Log In Successful."
                }
                showAlert = true
            }
        }
        
        func register () {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    alertTitle = "Registration Unsuccessful"
                    alertMessage = error.localizedDescription
                } else {
                    alertTitle = "Registered Successfully"
                    alertMessage = "Welcome to FoodFrenzy."
                }
                showAlert = true
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
