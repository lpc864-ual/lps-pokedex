import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var repeatPassword: String = ""
    @State private var isNavigationDashboard: Bool = false
    @State private var isNavigationSignIn: Bool = false

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

                            SecureField("", text: $repeatPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    // Botones
                    HStack {
                        Button(action: {
                            //CoreDataManager.instance.deleteAllUsers()
                            
                            // Verificar campos no vacios
                            if (username.isEmpty && password.isEmpty && repeatPassword.isEmpty) {
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

                            if (username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
                                alertMessage = "Repeat password vacio"
                                showAlert = true
                                return
                            }

                            // Verificar si las password coinciden desde el frontend
                            if (password != repeatPassword) {
                                alertMessage = "Password no coinciden"
                                showAlert = true
                                return
                            }
                            
                            // Verificamos que el username no este usado desde el backend
                            let loginResult = ViewModel.instance.registerUser(username: username, password: password)
                            if loginResult == "Registro exitoso." {
                                vm.currentUserNickname = username
                                self.isNavigationDashboard = true
                            } else {
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
                            self.isNavigationSignIn = true
                        }) {
                            Text("You have account?")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .fontWeight(.bold)
                        }
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
                    destination: SignInView(),
                    isActive: $isNavigationSignIn,
                    label: { EmptyView() }
                )
                
                NavigationLink(
                    destination: MenuView(),
                    isActive: $isNavigationDashboard,
                    label: { EmptyView() }
                )
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
