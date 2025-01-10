import Foundation

// Estructura que representa un Pokémon
struct Team {
    let pokemon: Pokemon
    let backImage: String   // Nombre del archivo de imagen trasera
}

// Datos de los equipos
struct TeamsData {
    static var playerTeam: [Team] = []
    static var rivalTeam: [Team] = []
    
    static func updatePlayerTeam(pokemonBattle: [Pokemon])  {
        // Crear un nuevo equipo dinámico basado en las selecciones
        for pokemon in pokemonBattle {
            //
            let newTeamMember = Team(pokemon: pokemon, backImage: "wartortleBack")
            
            TeamsData.playerTeam.append(newTeamMember)
        }
    }
    
    static func updateRivalTeam(pokemons: [Pokemon]) {
        // Asegurarse de que hay al menos 3 Pokémon en la lista
        guard pokemons.count >= 3 else {
            print("No hay suficientes Pokémon para formar un equipo rival.")
            return
        }
           
        // Seleccionar 3 Pokémon aleatorios
        let randomPokemons = pokemons.shuffled().prefix(3)
        
        for pokemon in randomPokemons {
            let newRivalMember = Team(pokemon: pokemon, backImage: "wartortleBack")
            
            TeamsData.rivalTeam.append(newRivalMember)
        }
    }
}


