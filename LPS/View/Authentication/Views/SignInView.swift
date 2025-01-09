//
//  SignInView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isNavigationDashboard: Bool = false
    @State private var isNavigationSignUp: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo dividido
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(
                                Color(
                                    red: 220.0 / 255.0, green: 10.0 / 255.0,
                                    blue: 45.0 / 255.0)
                            )
                            .frame(height: geometry.size.height / 2)
                        
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: geometry.size.height / 2)
                    }
                }
                
                // Contenido superpuesto
                VStack {
                    // Imagenes
                    VStack {
                        Image("pokedex")
                            .resizable()
                            .frame(width: 285, height: 98, alignment: .center)
                        
                        Image("pokeball")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                    }
                    .padding(.top, 100)
                    
                    // Formulario
                    VStack(spacing: 15) {
                        Text("Sign In")
                            .font(.system(size: 28, weight: .bold))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Username")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("", text: $username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            SecureField("", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Botones
                    Button(action: {
                        if (username.isEmpty && password.isEmpty) {
                            alertMessage = "Campos vacios"
                            showAlert = true
                            return
                        }
                        
                        if (username.isEmpty) {
                            alertMessage = "Username vacio"
                            showAlert = true
                            return
                        }
                        
                        if (password.isEmpty) {
                            alertMessage = "Password vacio"
                            showAlert = true
                            return
                        }
                        
                        let loginResult = ViewModel.instance.loginUser(username: username, password: password)
                        if loginResult == "Inicio de sesión exitoso." {
                            // Si el inicio de sesión es exitoso, navega a la siguiente pantalla
                            vm.currentUserNickname = username
                            self.isNavigationDashboard = true
                        } else {
                            // Si el inicio de sesión falla, mostrar el mensaje de error
                            alertMessage = loginResult
                            showAlert = true
                        }
                    }) {
                        Text("Start")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                            .fontWeight(.bold)
                    }
                    
                    Button(action: {
                        self.isNavigationSignUp = true
                    }) {
                        Text("You don't have an account?")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 100)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"), message: Text(alertMessage),
                        dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(
                    destination: MenuView(),
                    isActive: $isNavigationDashboard,
                    label: { EmptyView() }
                )
                
                NavigationLink(
                    destination: SignUpView(),
                    isActive: $isNavigationSignUp,
                    label: { EmptyView() }
                )
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
