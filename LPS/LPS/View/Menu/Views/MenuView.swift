//
//  MenuView.swift
//  LPS
//
//  Created by Aula03 on 10/12/24.
//

import SwiftUI

struct BusquedaView: View {
    @Binding var query: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)

            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text("Buscar...")
                        .foregroundColor(Color.gray)
                }
                TextField("", text: $query)
                    .frame(height: 8)
            }

        }
        .padding()
        .frame(width: 325, height: 40)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black.opacity(0.5), lineWidth: 2)
        )

    }
}

// Vista para mostrar las opciones en grupos de 3
struct GridView: View {
    let items: [String]
    let colors: [String: Color]
    @Binding var selectedFilters: [String]
    let isSingleSelection: Bool // Nuevo parámetro para definir si el filtro es único

    var body: some View {
        let groupedItems = items.chunked(into: 3)

        VStack {
            ForEach(groupedItems, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            if isSingleSelection {
                                // Si el item actual ya está seleccionado, lo deseleccionamos
                                if selectedFilters.contains(item.lowercased()) {
                                    selectedFilters.removeAll()
                                } else {
                                    // Si no está seleccionado, lo seleccionamos y deseleccionamos el resto
                                    selectedFilters = [item.lowercased()]
                                }
                            } else {
                                // Si ya existe, lo eliminamos
                                if let index = selectedFilters.firstIndex(of: item.lowercased()) {
                                    selectedFilters.remove(at: index)
                                } else {
                                    selectedFilters.append(item.lowercased())
                                }
                            }
                        }) {
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(colors[item] ?? Color.gray)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .opacity(selectedFilters.contains(item.lowercased()) ? 1 : 0.2)
                        }

                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .offset(y: -20)
    }
}



// Extensión para dividir un array en grupos
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

struct HeaderView: View {
    @Binding var view: Int
    //@State var isFavorite: Bool = false
    var username: String = ""
    @Binding var query: String

    @State private var isTypeOpen: Bool = false
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

    @State private var isGenerationOpen: Bool = false
    let generationColors: [String: Color] = [
        "1° Kanto": Color("normalColor"),
        "2° Johto": Color("fireColor"),
        "3° Hoenn": Color("waterColor"),
        "4° Sinnoh": Color("grassColor"),
        "5° Teselia": Color("electricColor"),
        "6° Kalos": Color("iceColor"),
        "7° Alola": Color("fightColor"),
        "8° Galar": Color("flyingColor"),
        "9° Paldea": Color("poisonColor"),
    ]
    
    @Binding var selectedFilters: [String]
    
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
                BusquedaView(query: $query)
                Button {

                } label: {
                    Image(systemName: 1 == 1 ? "heart" : "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
            }
            HStack(spacing: 12) {
                // Botón para mostrar las opciones de filtro de tipo
                Button(action: {
                    withAnimation {
                        isTypeOpen.toggle()
                        isGenerationOpen = false
                    }
                }) {
                    Text("Type")
                        .padding()
                        .frame(width: 120, height: 40)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }

//                // Botón para mostrar las opciones de filtro de generación
                Button(action: {
                    withAnimation {
                        isGenerationOpen.toggle()
                        isTypeOpen = false
                    }
                }) {
                    Text("Generation")
                        .padding()
                        .frame(width: 120, height: 40)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
            }
            .padding()
            .offset(x: -60)

            if isGenerationOpen {
                GridView(
                    items: Array(generationColors.keys.sorted()),
                    colors: generationColors,
                    selectedFilters: $selectedFilters,
                    isSingleSelection: true // Generación será de selección única
                )
            }

            if isTypeOpen {
                GridView(
                    items: Array(typeColors.keys.sorted()),
                    colors: typeColors,
                    selectedFilters: $selectedFilters,
                    isSingleSelection: false // Tipos permiten selección múltiple
                )
            }

        }
        .offset(y: 9)
    }
}

struct CardView: View {
    var pokemon: Pokemon
    var username: String
    
    // Función para construir el nombre del color
    private func getTypeColorName(_ type: String?) -> String {
        guard let type = type else { return "defaultColor" } // Si no hay tipo, devuelve un valor por defecto
        return type.lowercased() + "Color" // Construye el nombre del color
    }
    
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
                    pokemon.image.resizable().scaledToFit().frame(
                        width: 90, height: 100)
                }
                .offset(x: 15, y: 20)
            }
        }
        .padding()
        .background(Color(getTypeColorName(pokemon.types.first)) )
        .cornerRadius(20)
        .scaledToFit()
    }
}

// Vista para una fila de dos cards de Pokémon
struct PokemonRowView: View {
    @Binding var query: String
    @Binding var selectedFilters: [String]
    var pokemons: [Pokemon]
    var index: Int
    var currentUserNickname: String

    // Función para obtener el número de generación
    private func getGenerationFilter() -> Int {
        for filter in selectedFilters {
            if let match = filter.first(where: { $0.isNumber }), let number = Int(String(match)) {
                return number
            }
        }
        return 0 // Si no hay número en los filtros, devolvemos 0
    }
    
    var body: some View {
        // (getGenerationFilter() == 0 || pokemons[index].generation == String(getGenerationFilter()))
        
        if (query.isEmpty || pokemons[index].name.lowercased().contains(query.lowercased())) &&
            (selectedFilters.isEmpty || selectedFilters.allSatisfy { type in
                // Verificamos que todos los filtros seleccionados están presentes en los tipos del Pokémon
                pokemons[index].types.contains { $0.lowercased() == type.lowercased() }
            }) {
                // Si pasa todos los filtros, mostramos la CardView
                CardView(pokemon: pokemons[index], username: currentUserNickname)
                    .offset(x: 7)
        }
    }
}



// Vista principal para mostrar la lista de Pokémon
struct PokemonListView: View {
    @Binding var pokemons: [Pokemon]
    @Binding var pokemon_offset: Int
    @Binding var pokemon_names: [String]
    @Binding var query: String
    @Binding var selectedFilters: [String]
    var currentUserNickname: String
    
    // Función para cargar más Pokémon
    private func loadMorePokemons() async {
        pokemons = await ViewModel.instance.loadMorePokemons(currentPokemons: pokemons, pokemonNames: pokemon_names, offset: pokemon_offset)
        pokemon_offset = pokemons.count
    }

    // Función para cargar los Pokémon iniciales
    private func loadInitialPokemons() async {
        pokemon_names = await ViewModel.instance.filterPokemons(searchQuery: query, typeFilter: [], generationFilter: 0)
        pokemons = await ViewModel.instance.listPokemons(pokemon_names: pokemon_names, offset: pokemon_offset, limit: 10)
        pokemon_offset += 10
    }

    var body: some View {
        ScrollView {
            VStack {
                // Usamos stride para dividir los Pokémon en grupos de dos por cada fila
                ForEach(Array(stride(from: 0, to: pokemons.count, by: 2)), id: \.self) { index in
                    // Llamamos a la vista que maneja cada fila
                    HStack {
                        PokemonRowView(query: $query, selectedFilters: $selectedFilters, pokemons: pokemons, index: index, currentUserNickname: currentUserNickname)
                        PokemonRowView(query: $query, selectedFilters: $selectedFilters, pokemons: pokemons, index: index + 1, currentUserNickname: currentUserNickname)
                    }
                    .padding(0)
                    Spacer()
                    .onAppear {
                        if pokemons[index] == pokemons.dropLast().last {
                            Task {
                                await loadMorePokemons()
                            }
                        }
                    }
                }
            }
        }
        .task {
            await loadInitialPokemons()
        }
    }
}

struct BattleFooterView: View {
    var body: some View {
        HStack(spacing: 80) {

        }
        .frame(maxWidth: .infinity)
        .background(
            Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0)
        )

    }
}

struct FooterView: View {
    @Binding var view: Int
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
        .background(
            Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0)
        )

    }
}

// Vista principal MenuView
struct MenuView: View {
    @EnvironmentObject var vm: ViewModel
    @State var view: Int = 1  //0: BattleView, 1: mainView, 2: profileView
    @State var query: String = ""
    @State var selectedFilters: [String] = []
    @State var pokemon_names: [String] = []
    @State var pokemons: [Pokemon] = []
    @State var pokemon_offset: Int = 0
    
    var body: some View {
        VStack {
            if view != 2 {
                HeaderView(view: $view, username: view == 0 ? "" : vm.currentUserNickname, query: $query, selectedFilters: $selectedFilters)
                PokemonListView(pokemons: $pokemons, pokemon_offset: $pokemon_offset, pokemon_names: $pokemon_names, query: $query, selectedFilters: $selectedFilters, currentUserNickname: vm.currentUserNickname)
            }
            Spacer()
            FooterView(view: $view)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        let previewViewModel = ViewModel.instance
        previewViewModel.currentUserNickname = "Luis"

        return MenuView()
            .environmentObject(previewViewModel)
    }
}
