import Foundation

// Datos de los equipos
struct TeamsData {
    static var playerTeam: [Pokemon] = []
    static var rivalTeam: [Pokemon] = []
    
    // Variables para almacenar las medias de daño y precisión
    static var playerTeamAverageDamageValue: Double = 0
    static var rivalTeamAverageDamageValue: Double = 0
    static var playerTeamAverageAccuracyValue: Double = 0
    static var rivalTeamAverageAccuracyValue: Double = 0
    
    static func updatePlayerTeam(pokemonBattle: [Pokemon])  {
        playerTeam.removeAll()
        // Crear un nuevo equipo dinámico basado en las selecciones
        for pokemon in pokemonBattle {
            TeamsData.playerTeam.append(pokemon)
        }
    }
    
    static func updateRivalTeam(pokemons: [Pokemon]) {
        rivalTeam.removeAll()
        
        let rivalTeam = pokemons.shuffled().prefix(3)
        var move: Move?
        
        for pokemon in rivalTeam {
            // Copia del pokemon
            var pokemonCopy = pokemon
            // Asignar un movimiento aleatorio al Pokémon rival
            Task {
                // Obtenemos los movimientos del pokemon
                let newMoves = await ViewModel.instance.loadMoves(pokemon_id: pokemon.id)
                // Seleccionamos uno aleatorio
                if let randomMoveName = newMoves.randomElement() {
                    // Obtenemos el objeto Move
                    move = await ViewModel.instance.loadMove(name: randomMoveName)
                }
            }
            // Actualizamos el Pokémon con el movimiento
            pokemonCopy.move = move
            //Lo metemos al equipo
            TeamsData.rivalTeam.append(pokemonCopy)
        }
        
    }
    
    // Función para calcular la media del daño de los ataques (usando la propiedad power de Move)
    static func calculateAverageDamage(for team: [Pokemon]) -> Double {
        let totalDamage = team.reduce(0) { (result, teamMember) -> Int in
            return result + teamMember.move!.power
        }
        return team.isEmpty ? 0 : Double(totalDamage) / Double(team.count)
    }
    
    // Función para calcular la media de las probabilidades de los ataques (usando la propiedad accuracy de Move)
    static func calculateAverageAccuracy(for team: [Pokemon]) -> Double {
        // Calcular la media de las probabilidades de éxito (accuracy) de todos los movimientos de los Pokémon en el equipo
        let totalAccuracy = team.reduce(0) { (result, teamMember) -> Int in
            return result + teamMember.move!.accuracy
        }
        
        // Evitar la división por cero
        return team.isEmpty ? 0 : Double(totalAccuracy) / Double(team.count)
    }
    
    // Función para actualizar la media del daño del equipo del jugador
    static func updatePlayerTeamAverageDamage() {
        playerTeamAverageDamageValue = calculateAverageDamage(for: playerTeam)
    }
    
    // Función para actualizar la media del daño del equipo rival
    static func updateRivalTeamAverageDamage() {
        rivalTeamAverageDamageValue = calculateAverageDamage(for: rivalTeam)
    }
    
    // Función para actualizar la media de la precisión del equipo del jugador
    static func updatePlayerTeamAverageAccuracy() {
        playerTeamAverageAccuracyValue = calculateAverageAccuracy(for: playerTeam)
    }
    
    // Función para actualizar la media de la precisión del equipo rival
    static func updateRivalTeamAverageAccuracy() {
        rivalTeamAverageAccuracyValue = calculateAverageAccuracy(for: rivalTeam)
    }
}
