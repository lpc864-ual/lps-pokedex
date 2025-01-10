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
        for pokemon in pokemons {
            let newRivalMember = Team(pokemon: pokemon, backImage: "wartortleBack")
            
            TeamsData.rivalTeam.append(newRivalMember)
        }
    }
}
