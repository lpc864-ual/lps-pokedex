//
//  MenuView.swift
//  LPS
//
//  Created by Aula03 on 10/12/24.
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
    @Binding var view: Int
    //@State var isFavorite: Bool = false
    
    var username: String = ""
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
                Text(view == 0 ? "Team Select" : "Hi! " + username + " 👋")
                    .font(.system(size: 34))
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: 20)
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

struct CardView: View {
    var pokemon: Pokemon
    var username: String
    var body: some View {
        
        VStack {
            HStack {
                Text(pokemon.name)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("#" + String(format: "%04d", pokemon.id))
                    .foregroundStyle(.black.opacity(0.4))
            }
            
            HStack {
                VStack {
                    ForEach(pokemon.types, id: \.self) { type in
                        Text(type)
                            .frame(width: 60, height: 30)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            
                    }
                }
                ZStack {
                    Image("pokeball_bg")
                    pokemon.image.resizable().scaledToFit().frame(width: 90, height: 100)
                }
                .offset(x: 15, y: 20)
            }
        }
        .padding()
        .background(.green)
        .cornerRadius(20)
        .scaledToFit()
    }
}

struct BattleFooterView: View {
    var body: some View {
        HStack(spacing: 80) {
            
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0))
        
    }
}


struct FooterView: View {
    @Binding var view : Int
    var body: some View {
        HStack(spacing: 80) {
            // Boton de batallas
            Button(action: {
                view = 0
            }) {
                Image("battles")
                    .resizable()
                    .frame(width: 61, height: 65)
            }
            
            
            // Boton de menu
            Button(action: {
                view = 1
            }) {
                Image("pokeball")
                    .resizable()
                    .frame(width: 61, height: 65)
            }
            
            // Boton de perfil
            Button(action: {
                view = 2
            }) {
                Image("profile")
                    .resizable()
                    .frame(width: 61, height: 65)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0))
        
    }
}

struct MenuView: View {
    @EnvironmentObject var vm: ViewModel;
    @State var view: Int = 1
    @State var pokemon_names: [String] = []
    @State var pokemons: [Pokemon] = []
    @State var pokemon_offset: Int = 0
    let cardNames = ["bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon", "squirtle", "squirtle", "squirtle", "squirtle"]
    
    var body: some View {
        VStack {
            if (view != 2) {
                HeaderView(view: $view, username: view == 0 ? "" : vm.currentUserNickname)
                ScrollView {
                    VStack {
                        ForEach(Array(stride(from: 0, to: pokemons.count, by: 2)), id: \.self) { index in
                            HStack {
                                CardView(pokemon: pokemons[index], username: vm.currentUserNickname)
                                if index + 1 < pokemons.count {
                                    CardView(pokemon: pokemons[index + 1], username: vm.currentUserNickname)
                                } else {
                                    Spacer()
                                }
                            }.padding(0).onAppear {
                                if pokemons[index] == pokemons.dropLast().last {
                                    Task {
                                        pokemons = await ViewModel.instance.loadMorePokemons(currentPokemons: pokemons, pokemonNames: pokemon_names, offset: pokemon_offset)
                                        pokemon_offset = pokemons.count
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 2)
                    }
                }.task {
                    pokemon_names = await ViewModel.instance.filterPokemons(searchQuery: "", typeFilter: [], generationFilter: 1)
                    pokemons = await ViewModel.instance.listPokemons(pokemon_names: pokemon_names, offset: pokemon_offset, limit: 10)
                    pokemon_offset += 10
                }
                Spacer()
                FooterView(view: $view)
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    struct MenuView_Previews: PreviewProvider {
        static var previews: some View {
            let previewViewModel = ViewModel.instance
            previewViewModel.currentUserNickname = "Luis"
            
            return MenuView()
                .environmentObject(previewViewModel)
        }
    }
}
