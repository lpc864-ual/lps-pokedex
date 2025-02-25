import CoreData
import SwiftUI

struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let types: [String]
    let weight: Float
    let height: Float
    let stats: [String: Int]
    let image: Image
    let image_shiny: Image
    let evolution_chain_id: Int
    var move: Move? = nil
}

struct Move: Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let accuracy: Int
    let power: Int
}

class ViewModel: ObservableObject {

    // Singleton
    static let instance = ViewModel()
    
    // NSPersistentContainer y contexto de Core Data
    
    let contenedor: NSPersistentContainer
    let contexto: NSManagedObjectContext

    //
    var currentUserNickname: String
    
    init() {
        contenedor = NSPersistentContainer(name: "PokedexModel")
        contenedor.loadPersistentStores { (descripcion, error) in
            if let error = error {
                print("Error al cargar datos de Core Data: \(error)")
            } else {
                print("Carga de datos correcta")
            }
        }
        contexto = contenedor.viewContext
        currentUserNickname = ""
    }

    // Método auxiliar para obtener un usuario por su nombre de usuario
    private func getUser(username: String) -> PersonaEntity? {
        let request: NSFetchRequest<PersonaEntity> =
            PersonaEntity.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        do {
            let results = try contexto.fetch(request)
            return results.first
        } catch let error {
            print("Error al buscar usuario: \(error)")
            return nil
        }
    }

    // Método para verificar si un usuario existe con las credenciales proporcionadas (login)
    func loginUser(username: String, password: String) -> String {
        // Buscamos al usuario en el contexto por el nombre de usuario
        if let user = getUser(username: username) {
            // Comparamos las contraseñas
            if user.password == password {
                currentUserNickname = username
                print("Inicio de sesión exitoso para \(username).")
                return "Inicio de sesión exitoso."
            } else {
                print("Contraseña incorrecta.")
                return "Contraseña incorrecta."
            }
        } else {
            print("Usuario no encontrado.")
            return "Usuario no encontrado."
        }
    }

    // Método para guardar los cambios en el contexto de Core Data
    func save() {
        do {
            try contexto.save()
            print("Datos almacenados correctamente")
        } catch let error {
            print("Error al guardar datos \(error)")
        }
    }
    
    // Método para registrar un nuevo usuario
    func registerUser(username: String, password: String) -> String {
        // Verificamos si el usuario ya existe
        if let existingUser = getUser(username: username) {
            print("El usuario \(username) ya existe.")
            return "El usuario \(username) ya existe."
        }

        // Creamos una nueva instancia de PersonaEntity
        let newUser = PersonaEntity(context: contexto)
        newUser.username = username
        newUser.password = password

        // Guardamos los cambios
        save()
        currentUserNickname = username
        print("Usuario \(username) registrado correctamente.")
        return "Registro exitoso."
    }

    // Método para eliminar todos los usuarios
    func deleteAllUsers() {
        let context = ViewModel.instance.contexto

        // 1. Crear una solicitud de eliminación (delete request)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            PersonaEntity.fetchRequest()

        // 2. Crear una solicitud de eliminación para los resultados de la consulta
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            // 3. Ejecutar la solicitud de eliminación en el contexto
            try context.execute(deleteRequest)
            print("Todos los usuarios han sido eliminados.")

            // 4. Guardar los cambios en el contexto para asegurar que se persistan
            try context.save()
        } catch let error {
            print("Error al eliminar todos los usuarios: \(error)")
        }
    }
    
    // Método para obtener la lista de Pokémon favoritos de un usuario
    func getFavoritos(username: String) -> [String] {
        guard let user = getUser(username: username) else {
            print("Usuario no encontrado.")
            return []
        }

        // Desempaqueta el 'favoritos' directamente como NSSet
        guard let favoritosSet = user.favoritos else {
            return []
        }

        // Convierte el NSSet a un array de PokemonFavoritoEntity y mapea a los nombres
        let favoritosArray = favoritosSet.compactMap { favorito in
            return (favorito as? PokemonFavoritoEntity)?.pokemon_name
        }

        return favoritosArray
    }
    
    // Método para verificar si un Pokémon está en los favoritos de un usuario
    func isFavorito(username: String, pokemonName: String) -> Bool {
        guard let user = getUser(username: username) else {
            print("Usuario no encontrado.")
            return false
        }

        // Buscar si el Pokémon ya está en los favoritos del usuario
        if let favoritos = user.favoritos as? Set<PokemonFavoritoEntity> {
            return favoritos.contains(where: { $0.pokemon_name == pokemonName })
        }

        return false
    }
    
    // Método para añadir o eliminar un Pokémon favorito de un usuario
    func toggleFavorito(username: String, pokemonName: String) {
        guard let user = getUser(username: username) else {
            print("Usuario no encontrado.")
            return
        }

        // Buscar si el Pokémon ya está en los favoritos del usuario
        if let favoritos = user.favoritos as? Set<PokemonFavoritoEntity>,
           let pokemonFavoritoExistente = favoritos.first(where: { $0.pokemon_name == pokemonName }) {
            // Si ya existe, eliminarlo
            contexto.delete(pokemonFavoritoExistente)
            print("\(pokemonName) eliminado de los favoritos de \(username).")
        } else {
            // Si no existe, agregarlo
            let nuevoFavorito = PokemonFavoritoEntity(context: contexto)
            nuevoFavorito.pokemon_name = pokemonName
            nuevoFavorito.persona = user
            print("\(pokemonName) añadido a los favoritos de \(username).")
        }

        // Guardar los cambios
        save()
    }

    // Backend PokeAPI

    @State var pokemon_names: [String] = []
    @State var pokemons: [Pokemon] = []
    @State var pokemon_offset: Int = 0
    @State var move_names: [String] = []
    @State var moves: [Move] = []
    @State var move_offset: Int = 0

    func pokeApi(endpoint: String) async -> [String: Any] {
        guard let url = URL(string: "https://pokeapi.co/api/v2/\(endpoint)") else { return [:] }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return (try? JSONSerialization.jsonObject(with: data) as? [String: Any]) ?? [:]
        } catch {
            return [:]
        }
    }

    func loadPokemon(name_id: String) async -> Pokemon {
        let pokemon = await pokeApi(endpoint: "pokemon/\(name_id)")
        let pokemon_species = await pokeApi(endpoint: "pokemon-species/\(name_id)")
        let name = pokemon["name"] as! String
        let id = pokemon["id"] as! Int
        var description = ""
        if let flavorTextEntries = pokemon_species["flavor_text_entries"]
            as? [[String: Any]]
        {
            if let englishEntry = flavorTextEntries.first(where: {
                ($0["language"] as? [String: Any])?["name"] as? String == "en"
            }) {
                description = (englishEntry["flavor_text"] as! String)
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\u{0C}", with: " ")
            }
        }
        let types =
            (pokemon["types"] as? [[String: Any]])?.compactMap { typeEntry in
                return (typeEntry["type"] as? [String: Any])?["name"] as? String
            } ?? []
        let weight = pokemon["weight"] as! Float
        let height = pokemon["height"] as! Float
        let stats =
            (pokemon["stats"] as? [[String: Any]])?.reduce(
                into: [String: Int]()
            ) { result, statEntry in
                if let statName = (statEntry["stat"] as? [String: Any])?["name"]
                    as? String,
                    let baseStat = statEntry["base_stat"] as? Int
                {
                    result[statName] = baseStat
                }
            } ?? [:]
        let image: Image
        if let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"),
           let data = try? await URLSession.shared.data(from: url).0,
           let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        } else { // En caso de error, asignar una imagen vacía
            image = Image(systemName: "questionmark.circle")
        }
        let image_shiny: Image
        if let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/\(id).png"),
           let data = try? await URLSession.shared.data(from: url).0,
           let uiImage = UIImage(data: data) {
            image_shiny = Image(uiImage: uiImage)
        } else { // En caso de error, asignar una imagen vacía
            image_shiny = Image(systemName: "questionmark.circle")
        }
        var evolution_chain_id = 0
        if let species = pokemon_species["evolution_chain"] as? [String: Any] {
            evolution_chain_id = Int(
                (species["url"] as! String).dropFirst(42).dropLast(1))!
        }
        
        return Pokemon(
            id: id,
            name: name,
            description: description,
            types: types,
            weight: weight,
            height: height,
            stats: stats,
            image: image,
            image_shiny: image_shiny,
            evolution_chain_id: evolution_chain_id
        )
    }

    func listPokemons(pokemon_names: [String], offset: Int, limit: Int) async
        -> [Pokemon]
    {
        guard offset < pokemon_names.count else {
            return []
        }
        let endIndex = min(offset + limit, pokemon_names.count)
        let batchNames = Array(pokemon_names[offset..<endIndex])
        var pokemons: [Pokemon] = []
        for name in batchNames {
            let pokemon = await loadPokemon(name_id: name)
            pokemons.append(pokemon)
        }
        return pokemons
    }
    
    func loadMorePokemons(
        currentPokemons: [Pokemon],
        pokemonNames: [String],
        offset: Int,
        limit: Int = 10
    ) async -> [Pokemon] {
        // Verificar si hay más Pokémon para cargar
        guard offset < pokemonNames.count else {
            return currentPokemons // Si no hay más Pokémon, devuelve la lista actual
        }

        // Obtener los nuevos Pokémon
        let newPokemons = await listPokemons(
            pokemon_names: pokemonNames,
            offset: offset,
            limit: limit
        )
        
        // Devolver la lista actualizada
        return currentPokemons + newPokemons
    }

    func filterPokemons(
        searchQuery: String = "", typeFilter: [String] = [],
        generationFilter: Int = 0
    ) async -> [String] {
        var pokemon_names: [[String: Any]] =
            (await pokeApi(endpoint: "pokemon/?limit=100000&offset=0")[
                "results"] as? [[String: Any]] ?? [])
        if !typeFilter.isEmpty {
            for type in typeFilter {
                let pokemon_type =
                    (await pokeApi(endpoint: "type/\(type)")["pokemon"]
                    as! [[String: Any]]).compactMap { pokemonEntry in
                        return [
                            "url": (pokemonEntry["pokemon"] as! [String: Any])[
                                "url"]!,
                            "name": (pokemonEntry["pokemon"] as! [String: Any])[
                                "name"]!,
                        ]
                    }
                pokemon_names = pokemon_names.filter { nameDict in
                    pokemon_type.contains { typeDict in
                        (typeDict["name"] as? String)
                            == (nameDict["name"] as? String)
                    }
                }
            }
        }
        if generationFilter != 0 {
            let pokemon_generation =
                await pokeApi(endpoint: "generation/\(generationFilter)")[
                    "pokemon_species"] as! [[String: Any]]
            pokemon_names = pokemon_names.filter { nameDict in
                pokemon_generation.contains { typeDict in
                    (typeDict["name"] as? String)
                        == (nameDict["name"] as? String)
                }
            }
        }
        for i in 0..<pokemon_names.count {
            pokemon_names[i]["url"] = (pokemon_names[i]["url"] as! String)
                .replacingOccurrences(of: "-species", with: "")
        }
        let filteredPokemons =
            searchQuery.isEmpty
            ? pokemon_names.compactMap { pokemon in pokemon["name"] as? String }
            : pokemon_names.filter { pokemon in
                if let id = Int(searchQuery) {
                    return (pokemon["url"] as! String).dropFirst(34).dropLast(1)
                        .contains(searchQuery)
                } else {
                    return (pokemon["name"] as! String).lowercased().contains(
                        searchQuery.lowercased())
                }
            }.compactMap { pokemon in pokemon["name"] as? String }
        return filteredPokemons
    }

    func loadEvolutions(evolution_chain_id: Int) async -> [(
        Pokemon, String, Pokemon
    )] {
        var evolution_chain: [[String: Any]] = []
        if let chainData = await pokeApi(endpoint: "evolution-chain/\(evolution_chain_id)")["chain"] as? [String: Any] {
            evolution_chain = [chainData]
        } else {
            return []
        }
        var evolutions: [(Pokemon, String, Pokemon)] = []
        while !evolution_chain.isEmpty {
            var aux: [[String: Any]] = []
            for ce in evolution_chain {
                let next_evolutions = (ce["evolves_to"] as! [Any])
                if next_evolutions.isEmpty {
                    continue
                }
                let pokemon1 = await loadPokemon(
                    name_id: (ce["species"] as! [String: Any])["name"] as! String)
                for ne in next_evolutions {
                    let pokemon2 = await loadPokemon(
                        name_id: ((ne as! [String: Any])["species"]
                            as! [String: Any])["name"] as! String)
                    let details =
                        (((ne as! [String: Any])["evolution_details"] as! [Any])[
                            0] as! [String: Any])
                    var tag =
                        (details["trigger"] as! [String: Any])["name"]
                        as! String
                    if tag == "level-up" {
                        tag =
                            "Level "
                            + ((details["min_level"] as? Int).map(String.init)
                                ?? "")
                    } else if tag == "use-item" {
                        tag =
                            "Item "
                            + String(
                                (details["item"] as! [String: Any])["name"]
                                    as! String)
                    } else {
                        tag = "Other"
                    }
                    evolutions.append((pokemon1, tag, pokemon2))
                    aux.append(ne as! [String: Any])
                }
            }
            evolution_chain = aux
        }
        return evolutions
    }

    func loadMoreMoves(
        currentMoves: [Move],
        moveNames: [String],
        offset: Int,
        limit: Int = 10
    ) async -> [Move] {
        guard offset < moveNames.count else {
            return []
        }
        var newMoves = await listMoves(
            move_names: moveNames, offset: offset, limit: limit)
        if !newMoves.isEmpty {
            DispatchQueue.main.async {
                newMoves.append(contentsOf: currentMoves)
            }
        }
        return newMoves
    }

    func loadMoves(pokemon_id: Int) async -> [String] {
        let moves =
            await pokeApi(endpoint: "pokemon/\(pokemon_id)")["moves"]
            as? [[String: Any]] ?? []
        var result: [String] = []
        for move in moves {
            result.append((move["move"] as! [String: Any])["name"] as! String)
        }
        return result
    }

    func listMoves(move_names: [String], offset: Int, limit: Int) async
        -> [Move]
    {
        guard offset < move_names.count else {
            return []
        }
        let endIndex = min(offset + limit, move_names.count)
        let batchNames = Array(move_names[offset..<endIndex])
        var moves: [Move] = []
        for name in batchNames {
            let move = await loadMove(name: name)
            moves.append(move)
        }
        return moves
    }

    func loadMove(name: String) async -> Move {
        let info = await pokeApi(endpoint: "move/" + name)
        let id = info["id"] as! Int
        var description = ""
        if let flavorTextEntries = info["flavor_text_entries"]
            as? [[String: Any]]
        {
            if let englishEntry = flavorTextEntries.first(where: {
                ($0["language"] as? [String: Any])?["name"] as? String == "en"
            }) {
                description = (englishEntry["flavor_text"] as! String)
                    .replacingOccurrences(of: "\n", with: " ")
                    .replacingOccurrences(of: "\u{0C}", with: " ")
            }
        }
        let accuracy = info["accuracy"] as? Int ?? 100
        let power = info["power"] as? Int ?? 0
        return Move(
            id: id,
            name: name,
            description: description,
            accuracy: accuracy,
            power: power
        )
    }
}
