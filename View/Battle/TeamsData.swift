import Foundation

// Estructura que representa un Pokémon
struct Team {
    let name: String
    let frontImage: String  // Nombre del archivo de imagen frontal
    let backImage: String   // Nombre del archivo de imagen trasera
    let attackPower: Int    // Potencia de ataque
    let attackAccuracy: Int // Precisión del ataque (porcentaje 0-100)
}

// Datos de los equipos
struct TeamsData {
    static let playerTeam: [Team] = [
        Team(name: "Pikachu", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 50, attackAccuracy: 90),
        Team(name: "Charizard", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 70, attackAccuracy: 85),
        Team(name: "Bulbasaur", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 40, attackAccuracy: 95)
    ]
    
    static let rivalTeam: [Team] = [
        Team(name: "Squirtle", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 45, attackAccuracy: 90),
        Team(name: "Gengar", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 65, attackAccuracy: 80),
        Team(name: "Onix", frontImage: "bulbasur", backImage: "wartortleBack", attackPower: 60, attackAccuracy: 75)
    ]
}
