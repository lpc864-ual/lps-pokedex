//
//  SignUpView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct SignUpView: View {
   // @StateObject private var viewModel = SignInViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View{
        ZStack {
            // Fondo dividido
            GeometryReader { geometry in
                VStack(spacing: 0){
                    Rectangle()
                        .fill(Color(red: 220.0 / 255.0, green: 10.0 / 255.0, blue: 45.0 / 255.0))
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
                        .frame(width: 285, height: 98, alignment:.center)
                        
                    Image("pokeball")
                        .resizable()
                        .frame(width: 150, height: 150, alignment:.center)
                }
                .padding(.top, 120)
                
                // Formulario
                VStack(spacing: 15) {
                    Text("Sign Up")
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Repeat password")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        SecureField("", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // Botones
                HStack {
                    Button(action: {
                        
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
                        
                    }) {
                        Text("You have account?")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .fontWeight(.bold)
                    }
                }
               
            }
            .padding(.horizontal, 30)
            .padding(.top, 100)
        }
       
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
