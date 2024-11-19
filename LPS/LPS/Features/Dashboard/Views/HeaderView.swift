//
//  HeaderView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct BusquedaView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Buscar...")
                        .foregroundColor(Color.gray)
                }
                TextField("", text: $text)
                    .frame(height: 8)
            }
            
        }
        .padding()
        .frame(width: 325, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.5), lineWidth: 2)
        )
    
    }
}

struct FilterView: View {
    // Texto boton
    var text: String
    
    // Width
    var width: CGFloat
    
    // Estado para controlar si el listado de filtros está abierto
    @State private var isOpen: Bool = false
    
    // Estado para manejar el filtro seleccionado
    @State private var selectedFilter: String = ""
    
    // Opciones de filtro disponibles
    let options = ["1", "2", "3", "4"]
    
    var body: some View {
        VStack {
            // Botón para mostrar las opciones de filtro
            Button(action: {
                // Alterna el estado de visibilidad de las opciones
                isOpen.toggle()
            }) {
                Text(text)
                    .padding()
                    .frame(width: width, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }
            
            // Mostrar las opciones solo si isOpen es verdadero
            if isOpen {
                VStack {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            // Seleccionar filtro y cerrar las opciones
                            selectedFilter = option
                            isOpen = false
                        }) {
                            Text(option)
                                .padding()
                                .frame(width: width, height: 32)
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.top, 4)
                    }
                }
                .transition(.move(edge: .top)) // Transición de deslizamiento
                .animation(.easeInOut, value: isOpen) // Animación para el desplegable
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}


struct HeaderView: View {
    @State var query: String = ""
    @State var text: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("Hi! Stanley 👋")
                    .font(.system(size: 34))
                    .fontWeight(.medium)
                    .offset(x: -80)
            }

            HStack {
                BusquedaView(text: $query)
                Button {

                } label: {
                    Image(systemName: 1 == 1 ? "heart" : "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
            }
            HStack (spacing: -80) {
                FilterView(text: "Filter", width: CGFloat(82))
                FilterView(text: "Generation", width: CGFloat(120))
                FilterView(text: "Region", width: CGFloat(85))
            }
            .offset(x: -35)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
