import SwiftUI

struct VistaMovimientos: View {
    var moves: [Move]
    var getBackgroundColor: (String) -> Color // Método para obtener el color
    var pokemonType: String // El tipo del Pokémon

    var body: some View {
        ScrollView{
            
            VStack(spacing: 20) {
                ForEach(moves, id: \.name) { move in
                    VStack(alignment: .leading, spacing: 10) {
                        // Nombre del movimiento
                        HStack {
                            Text(move.name)
                                .font(.headline)
                                .bold()
                                .foregroundColor(getBackgroundColor(pokemonType))
                            
                            Spacer()
                            
                            // Precisión e ícono
                            HStack(spacing: 10) {
                                Image(systemName: "scope") // Ícono de precisión
                                    .foregroundColor(.black.opacity(0.7))
                                Text("\(move.accuracy ?? 100)%") // Precisión (si existe)
                                    .foregroundColor(.black)
                                
                                Image(systemName: "bolt.fill") // Ícono de poder
                                    .foregroundColor(.yellow.opacity(0.7))
                                Text("\(move.power)") // Poder del movimiento
                                    .foregroundColor(.black)
                            }
                        }
                        
                        // Descripción del movimiento
                        Text(move.description ?? "No description available.")
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(getBackgroundColor(pokemonType).opacity(0.5), lineWidth: 1.5)
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.top, 10)
        }
    }
}
