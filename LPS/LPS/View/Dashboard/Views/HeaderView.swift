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
    // Texto del botón principal
    var text: String

    // Ancho del botón principal y de las opciones
    var width: CGFloat

    // Diccionario de opciones y colores asociados
    var optionsWithColors: [String: Color]

    // Estado para controlar si el listado de filtros está abierto
    @State private var isOpen: Bool = false

    // Estado para manejar el filtro seleccionado
    @State private var selectedFilter: String = ""

    var body: some View {
        VStack {
            // Botón para mostrar las opciones de filtro

            Button(action: {
                // Alterna el estado de visibilidad de las opciones
                isOpen.toggle()
            }) {
                Text(selectedFilter.isEmpty ? text : selectedFilter)  // Muestra el texto seleccionado o el texto genérico
                    .padding()
                    .frame(width: width, height: 32)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }

            // Mostrar las opciones solo si isOpen es verdadero
            if isOpen {
                // Hacer scroll si hay demasiados elementos
                VStack(alignment: .leading, spacing: 8) {
                    // Dividir las opciones en filas de cinco elementos
                    ForEach(
                        chunked(
                            Array(optionsWithColors.keys.sorted()), into: 3),
                        id: \.self
                    ) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { option in
                                Button(action: {
                                    // Seleccionar filtro y cerrar las opciones
                                    selectedFilter = option
                                    isOpen = false
                                }) {
                                    Text(option)
                                        .padding()
                                        .frame(width: width, height: 32)  // Ajustar ancho por fila
                                        .background(
                                            optionsWithColors[option]
                                                ?? Color.white
                                        )
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    Color.gray, lineWidth: 1))
                                }
                            }
                        }
                        .offset(x: 68)
                    }
                }

            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    // Función auxiliar para dividir el array en grupos de tamaño dado
    func chunked<T>(_ array: [T], into size: Int) -> [[T]] {
        stride(from: 0, to: array.count, by: size).map {
            Array(array[$0..<min($0 + size, array.count)])
        }
    }
}

struct HeaderView: View {
    var username: String
    @State var query: String = ""
    @State var text: String = ""
    @State private var selectedTypes: Set<String> = []
    let typeColors: [String: Color] = [
        "Normal": Color("normalColor"),
        "Fire": Color("fireColor"),
        "Water": Color("waterColor"),
        "Grass": Color("grassColor"),
        "Electric": Color("electricColor"),
        "Ice": Color("iceColor"),
        "Fighting": Color("fightColor"),
        "Flying": Color("flyingColor"),
        "Poison": Color("poisonColor"),
        "Ground": Color("groundColor"),
        "Rock": Color("rockColor"),
        "Bug": Color("bugColor"),
        "Ghost": Color("ghostColor"),
        "Steel": Color("steelColor"),
        "Dragon": Color("dragonColor"),
        "Dark": Color("darkColor"),
        "Fairy": Color("fairyColor"),
        "Psychic": Color("psychicColor"),
    ]

    var selectedGenerations: Set<String> = []
    let generationColors: [String: Color] = [
        "1° Kanto": Color("kantoColor"),
        "2° Johto": Color("johtoColor"),
        "3° Hoenn": Color("hoennColor"),
        "4° Sinnoh": Color("sinnohColor"),
        "5° Teselia": Color("teseliaColor"),
        "6° Kalos": Color("kalosColor"),
        "7° Alola": Color("alolaColor"),
        "8° Galar": Color("galarColor"),
        "9° Paldea": Color("paldeaColor"),
    ]

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
            HStack(spacing: -140) {
                FilterView(
                    text: "Type", width: CGFloat(120),
                    optionsWithColors: typeColors)
                FilterView(
                    text: "Generation", width: CGFloat(120),
                    optionsWithColors: generationColors)
            }
            .offset(x: -56)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(username: "")
    }
}
