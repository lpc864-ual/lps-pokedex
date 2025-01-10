import SwiftUI

// Función asíncrona común para manejar la lógica de filtrado con parámetros pasados por referencia
func applyFilters(query: Binding<String>, selectedTypeFilters: Binding<[String]>, selectedGenerationFilters: Binding<Int>, isFavorito: Binding<Bool>, pokemon_names: Binding<[String]>, pokemons: Binding<[Pokemon]>, pokemon_offset: Binding<Int>, isLoading: Binding<Bool>, username: String
) async {
    isLoading.wrappedValue = true
    let lastQuery = query.wrappedValue
    let lastSelectedTypeFilters = selectedTypeFilters.wrappedValue
    let lastSelectedGenerationFilters = selectedGenerationFilters.wrappedValue
    let lastIsFavorito = isFavorito.wrappedValue
    // Ejecuta los filtros en un Task asíncrono
    Task {
        // Si los filtros han cambiado después de haber comenzado, no continuamos
        guard lastQuery == query.wrappedValue && lastSelectedTypeFilters == selectedTypeFilters.wrappedValue && lastSelectedGenerationFilters == selectedGenerationFilters.wrappedValue && lastIsFavorito == isFavorito.wrappedValue else { return }
        var auxPokemonNames = await ViewModel.instance.filterPokemons(
            searchQuery: query.wrappedValue,
            typeFilter: selectedTypeFilters.wrappedValue,
            generationFilter: selectedGenerationFilters.wrappedValue
        )
        if isFavorito.wrappedValue {
            auxPokemonNames = auxPokemonNames.filter { ViewModel.instance.getFavoritos(username: username).contains($0) }
        }
        // Verifica nuevamente si los filtros actuales siguen siendo relevantes
        guard lastQuery == query.wrappedValue && lastSelectedTypeFilters == selectedTypeFilters.wrappedValue && lastSelectedGenerationFilters == selectedGenerationFilters.wrappedValue && lastIsFavorito == isFavorito.wrappedValue else { return }
        let auxPokemons = await ViewModel.instance.listPokemons(
            pokemon_names: auxPokemonNames,
            offset: 0,
            limit: 10
        )
        // Solo actualiza los valores si los filtros son los últimos
        guard lastQuery == query.wrappedValue && lastSelectedTypeFilters == selectedTypeFilters.wrappedValue && lastSelectedGenerationFilters == selectedGenerationFilters.wrappedValue && lastIsFavorito == isFavorito.wrappedValue else { return }
        pokemon_names.wrappedValue = auxPokemonNames
        pokemons.wrappedValue = auxPokemons
        pokemon_offset.wrappedValue = auxPokemons.count
        isLoading.wrappedValue = false
    }
}

struct BusquedaView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var query: String
    @Binding var pokemon_names: [String]
    @Binding var pokemons: [Pokemon]
    @Binding var pokemon_offset: Int
    @Binding var selectedTypeFilters: [String]
    @Binding var selectedGenerationFilters: Int
    @Binding var isFavorito: Bool
    @Binding var isLoading: Bool
    
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
                    .onChange(of: query) {
                        // Ejecuta los filtros en un Task asíncrono
                        Task {
                            await applyFilters(query: $query, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, isLoading: $isLoading, username: vm.currentUserNickname)
                        }
                    }
            }
        }
        .padding()
        .frame(width: 325, height: 40)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black.opacity(0.5), lineWidth: 2))
    }
}

// Vista para mostrar las opciones en grupos de 3
struct GridView: View {
    @EnvironmentObject var vm: ViewModel
    let items: [String]
    let colors: [String: Color]
    @Binding var query: String
    @Binding var pokemon_names: [String]
    @Binding var pokemons: [Pokemon]
    @Binding var pokemon_offset: Int
    @Binding var selectedTypeFilters: [String]
    @Binding var selectedGenerationFilters: Int
    @Binding var isFavorito: Bool
    @Binding var isLoading: Bool
    let isSingleSelection: Bool // Nuevo parámetro para definir si el filtro es único
    
    var body: some View {
        let groupedItems = items.chunked(into: 3)
        
        VStack {
            ForEach(groupedItems, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        Button(action: {
                            if isSingleSelection {
                                if selectedGenerationFilters == Int(item.lowercased().prefix(1)) {
                                    selectedGenerationFilters = 0
                                } else {
                                    selectedGenerationFilters = Int(item.lowercased().prefix(1)) ?? 0
                                }
                            } else {
                                // Si ya existe, lo eliminamos
                                if let index = selectedTypeFilters.firstIndex(of: item.lowercased()) {
                                    selectedTypeFilters.remove(at: index)
                                } else {
                                    selectedTypeFilters.append(item.lowercased())
                                }
                            }
                            Task {
                                await applyFilters(query: $query, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, isLoading: $isLoading, username: vm.currentUserNickname)
                            }
                        }) {
                            Text(item)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(colors[item] ?? Color.gray)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                                .opacity(selectedTypeFilters.contains(item.lowercased()) || (isSingleSelection && selectedGenerationFilters == Int(item.lowercased().prefix(1))) ? 1 : 0.2)
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
    @EnvironmentObject var vm: ViewModel
    @Binding var view: Int
    @Binding var isFavorito: Bool
    @Binding var query: String
    @Binding var pokemon_names: [String]
    @Binding var pokemons: [Pokemon]
    @Binding var pokemon_offset: Int
    @Binding var isContinuar: Bool
    
    @State private var isTypeOpen: Bool = false
    let typeColors: [String: Color] = [
        "Normal": Color("normalColor"),
        "Fire": Color("fireColor"),
        "Water": Color("waterColor"),
        "Grass": Color("grassColor"),
        "Electric": Color("electricColor"),
        "Ice": Color("iceColor"),
        "Fighting": Color("fightingColor"),
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
        "7° Alola": Color("fightingColor"),
        "8° Galar": Color("flyingColor"),
        "9° Paldea": Color("poisonColor"),
    ]
    
    @Binding var selectedTypeFilters: [String]
    @Binding var selectedGenerationFilters: Int
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(view == 0 ? (isContinuar ? "Team Preview" : "Team Select") : "Hi! " + vm.currentUserNickname + " 👋")
                    .font(.system(size: 34))
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: 20)
            }
            
            if (!isContinuar) {
                HStack {
                    BusquedaView(query: $query, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, isLoading: $isLoading)
                    Button {
                        isFavorito = !isFavorito
                        Task {
                            await applyFilters(query: $query, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, isLoading: $isLoading, username: vm.currentUserNickname)
                        }
                    } label: {
                        Image(systemName: $isFavorito.wrappedValue ? "heart.fill" : "heart")
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
                    // Botón para mostrar las opciones de filtro de generación
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
                        query: $query,
                        pokemon_names: $pokemon_names,
                        pokemons: $pokemons,
                        pokemon_offset: $pokemon_offset,
                        selectedTypeFilters: $selectedTypeFilters,
                        selectedGenerationFilters: $selectedGenerationFilters,
                        isFavorito: $isFavorito,
                        isLoading: $isLoading,
                        isSingleSelection: true // Generación será de selección única
                    )
                }
                
                if isTypeOpen {
                    GridView(
                        items: Array(typeColors.keys.sorted()),
                        colors: typeColors,
                        query: $query,
                        pokemon_names: $pokemon_names,
                        pokemons: $pokemons,
                        pokemon_offset: $pokemon_offset,
                        selectedTypeFilters: $selectedTypeFilters,
                        selectedGenerationFilters: $selectedGenerationFilters,
                        isFavorito: $isFavorito,
                        isLoading: $isLoading,
                        isSingleSelection: false // Tipos permiten selección múltiple
                    )
                }
            }
        }
        .offset(y: 9)
    }
}

struct CardView: View {
    let pokemon: Pokemon
    @Binding var view: Int
    @Binding var pokemon_battle: [Pokemon]
    @Binding var pokemon_images: [Image]
    
    // Función para construir el nombre del color
    private func getTypeColorName(_ type: String?) -> String {
        guard let type = type else { return "defaultColor" } // Si no hay tipo, devuelve un valor por defecto
        return type.lowercased() + "Color" // Construye el nombre del color
    }
    
    var body: some View {
        NavigationLink(destination: VistaDetalle(pokemon: pokemon)) {
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
                                .background(
                                    RoundedRectangle(cornerRadius: 32)
                                        .fill(Color(getTypeColorName(type)))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 32)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 32))
                        }
                    }
                    ZStack {
                        Image("pokeball_bg")
                        pokemon.image.resizable().scaledToFit().frame(
                            width: 90, height: 100)
                        if (view == 0) {
                            //BOTON DE AGREGAR POKEMON
                            Button(action: {
                                if (pokemon_images.count != 3) {
                                    pokemon_battle.append(pokemon)
                                    pokemon_images.append(pokemon.image)
                                }
                            }){
                                Image("addPoke")
                                    .padding([.top, .leading], 50.0)
                            }
                            
                        }
                    }
                    .offset(x: 17, y: 20)
                }
            }
            .padding()
            .background(Color(getTypeColorName(pokemon.types.first)) )
            .cornerRadius(20)
            .scaledToFit()
            .offset(x: 0)
            .frame(maxWidth: 190)
        }
    }
}

//GUILLERMO: ENCARGADO DE TERMINARLO Y DEJARLO COMO EL FIGMA
struct CardBattleView: View {
    var pokemon: Pokemon
    //@Binding var view: Int
    //@Binding var pokemon_battle: [Pokemon]
    //@Binding var pokemon_images: [Image]
    
    
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
                            .frame(width: 240, height: 30)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color(getTypeColorName(type)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                    }
                }
                ZStack {
                    Image("pokeball_bg")
                    pokemon.image.resizable().scaledToFit().frame(width: 90, height: 100)
                    // GUILLERMO: usar propieda move de pokemon (pokemon.move) para mostrar el movimiento escogido. (¡Propidad opcional! Te saltara error, pero no te rayes. Dile al chat para que te lo solucione)
                    
                    //if (view == 0) {
                        
                    //}
                }
                .offset(x: 17, y: 20)
            }
        }
        .padding()
        .background(Color(getTypeColorName(pokemon.types.first)))
        .cornerRadius(20)
        .scaledToFit()
        .offset(x: 0)
        .frame(maxWidth: 190)
    }
}

// Vista principal para mostrar la lista de Pokémon
struct PokemonListView: View {
    @EnvironmentObject var vm: ViewModel
    @Binding var pokemon_names: [String]
    @Binding var pokemons: [Pokemon]
    @Binding var pokemon_offset: Int
    @Binding var query: String
    @Binding var selectedTypeFilters: [String]
    @Binding var selectedGenerationFilters: Int
    @Binding var isFavorito: Bool
    @Binding var view: Int
    @Binding var pokemon_battle: [Pokemon]
    @Binding var pokemon_images: [Image]
    @Binding var isLoading: Bool
    
    var body: some View {
        ScrollView {
            if isLoading {
                // Indicador de carga mientras se procesan los pokemons
                ProgressView("Loading pokemons...")
                    .padding()
            } else {
                LazyVStack {
                    // Dividimos los Pokémon en grupos de dos por cada fila
                    ForEach(Array(stride(from: 0, to: pokemons.count, by: 2)), id: \.self) { index in
                        HStack {
                            // Mostrar el primer Pokémon en la fila
                            CardView(pokemon: pokemons[index], view: $view, pokemon_battle: $pokemon_battle, pokemon_images: $pokemon_images)
                            // Mostrar el segundo Pokémon en la fila, si existe
                            if index + 1 < pokemons.count {
                                CardView(pokemon: pokemons[index + 1], view: $view, pokemon_battle: $pokemon_battle, pokemon_images: $pokemon_images)
                            } else {
                                Spacer().frame(maxWidth: 198)
                            }
                        }
                        .padding(0)
                        .onAppear {
                            // Si el usuario ha llegado al final del contenido actual, carga más Pokémon
                            if index >= pokemons.count - 2 { // Detecta las últimas filas
                                Task {
                                    pokemons = await ViewModel.instance.loadMorePokemons(currentPokemons: pokemons, pokemonNames: pokemon_names, offset: pokemon_offset)
                                    pokemon_offset = pokemons.count
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await applyFilters(query: $query, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, isLoading: $isLoading, username: vm.currentUserNickname)
        }
    }
}

struct ProfileView: View {
    @Binding var view: Int
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        
        // Contenedor principal
        VStack(spacing: 40) {
            Spacer()
            
            // Avatar
            Image("avatarImage") // Usa una imagen en tus Assets
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.red, lineWidth: 2) // Borde circular
                )
                .offset(y: 25)
            
            // Texto centrado
            Text(vm.currentUserNickname)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            // Botón de salida
            
            Button(action: {
                view = 3
            }) {
                Image("exit") // Icono del sistema
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color.red))
                    .padding()
            }

            Spacer()
        }
        
    }
}

struct BattleFooterView: View {
    @Binding var pokemon_battle: [Pokemon]
    @Binding var pokemon_images: [Image]
    @Binding var isContinuar: Bool // Propiedad de estado
    //@Binding var isEmpezar: Bool // Propiedad de estado
    @Binding var pokemons: [Pokemon]
    
    // Función asincrónica para cargar y asignar un movimiento aleatorio
    func loadAndAssignMove(to pokemon: Pokemon) {
        Task {
            // Primero obtenemos los movimientos posibles (newMoves)
            let newMoves = await ViewModel.instance.loadMoves(pokemon_id: pokemon.id)
            
            // Verificamos si newMoves tiene elementos
            if !newMoves.isEmpty {
                // Seleccionamos un movimiento aleatorio de los movimientos disponibles
                let randomMoveName = newMoves.randomElement()!
                
                // Ahora usamos el nombre del movimiento para obtener el objeto Move
                let move = await ViewModel.instance.loadMove(name: randomMoveName)
                
                // Actualizamos el Pokémon con el movimiento
                if let index = pokemon_battle.firstIndex(where: { $0.id == pokemon.id }) {
                    pokemon_battle[index].move = move
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if !isContinuar {
                    // Mostrar las imágenes seleccionadas con botones de eliminar
                    ForEach(0..<pokemon_images.count, id: \.self) { index in
                        ZStack {
                            pokemon_images[index]
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding(4)
                            
                            // Botón de eliminar en la esquina superior derecha
                            Button(action: {
                                // Eliminar la imagen de la lista
                                pokemon_battle.remove(at: index)
                                pokemon_images.remove(at: index)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: 20, y: -20) // Ajustar posición
                        }
                    }
                } else {
                    VStack {
                        HStack {
                            // Botón para volver a la selección de Pokémon
                            Button(action: {
                                // Cambiar el estado de isContinuar para volver
                                isContinuar.toggle()
                            }) {
                                Image("continuar")
                                    .resizable()
                                    .rotationEffect(.degrees(180)) // Rotar 180 grados
                                    .frame(width: 40, height: 40)
                            }
                            
                            NavigationLink(destination: BattleView()) {
                                Button(action: {
                                    // Nuestro equipo
                                    TeamsData.updatePlayerTeam(pokemonBattle: pokemon_battle)
                                    // Equipo Rival
                                    let rivalTeam = pokemons.shuffled().prefix(3)
                                    for pokemon in rivalTeam {
                                        Task {
                                                await loadAndAssignMove(to: pokemon)
                                            }
                                    }
                                    
                                    TeamsData.updateRivalTeam(pokemons: pokemons)
                                }) {
                                    Image("start")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    }
                }
                
                // Botón de continuar
                if !isContinuar {
                    Button(action: {
                        // Cambiar el estado de isContinuar
                        isContinuar.toggle()
                    }) {
                        Image("continuar")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .opacity(pokemon_images.count == 3 ? 1.0 : 0.5) // Indicador visual
                    }
                    .disabled(pokemon_images.count != 3) // Deshabilitar si no hay 3 seleccionados
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0))
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .frame(height: 2)
        }
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
    @State var view: Int = 1  //0: BattleView, 1: mainView, 2: profileView; 3: exit
    @State var query: String = ""
    @State var selectedTypeFilters: [String] = []
    @State var selectedGenerationFilters: Int = 0
    @State var isFavorito: Bool = false
    @State var pokemon_names: [String] = []
    @State var pokemons: [Pokemon] = []
    @State var pokemon_offset: Int = 0

    @State var pokemon_battle: [Pokemon] = []
    @State var pokemon_images: [Image] = []

    @State var isContinuar: Bool = false
    @State var isLoading: Bool = true

    var body: some View {
        NavigationView {
            if view != 3 {
                VStack {
                    if view != 2 {
                        HeaderView(view: $view, isFavorito: $isFavorito, query: $query, pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, isContinuar: $isContinuar, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isLoading: $isLoading)
                        if (!isContinuar) {
                            PokemonListView(pokemon_names: $pokemon_names, pokemons: $pokemons, pokemon_offset: $pokemon_offset, query: $query, selectedTypeFilters: $selectedTypeFilters, selectedGenerationFilters: $selectedGenerationFilters, isFavorito: $isFavorito, view: $view, pokemon_battle: $pokemon_battle, pokemon_images: $pokemon_images, isLoading: $isLoading)
                        } else {
                            ForEach(pokemon_battle, id: \.id) { pokemon in
                                // Llamamos a loadMoves cuando el Pokémon aparece en la vista
                                CardBattleView(pokemon: pokemon)
                                    .onAppear {
                                        loadAndAssignMove(to: pokemon)
                                    }
                            }
                        }

                        if view == 0 {
                            BattleFooterView(pokemon_battle: $pokemon_battle, pokemon_images: $pokemon_images, isContinuar: $isContinuar, pokemons: $pokemons)
                        }
                    } else {
                        ProfileView(view: $view)
                    }

                    Spacer()
                    FooterView(view: $view)
                }
                .navigationBarBackButtonHidden(true)
            } else {
                ZStack {
                    SignInView()
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // Función asincrónica para cargar y asignar un movimiento aleatorio
    func loadAndAssignMove(to pokemon: Pokemon) {
        Task {
            // Primero obtenemos los movimientos posibles (newMoves)
            let newMoves = await ViewModel.instance.loadMoves(pokemon_id: pokemon.id)
            
            // Verificamos si newMoves tiene elementos
            if !newMoves.isEmpty {
                // Seleccionamos un movimiento aleatorio de los movimientos disponibles
                let randomMoveName = newMoves.randomElement()!
                
                // Ahora usamos el nombre del movimiento para obtener el objeto Move
                let move = await ViewModel.instance.loadMove(name: randomMoveName)
                
                // Actualizamos el Pokémon con el movimiento
                if let index = pokemon_battle.firstIndex(where: { $0.id == pokemon.id }) {
                    pokemon_battle[index].move = move
                }
            }
        }
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
