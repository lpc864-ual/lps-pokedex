import SwiftUI

struct VistaEvolution: View {
    var evolutions: Int
    var getBackgroundColor: (String) -> Color
    var pokemonType: String
    
    var body: some View {
        ScrollView{
            /*VStack(spacing: 20) {
                if evolutions.count < 2 {
                    // Mensaje si no hay evoluciones más allá de la base
                    Text("Pokemon sin evolución")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ForEach(evolutions.indices.dropFirst(), id: \.self) { index in
                        let currentEvolution = evolutions[index]
                        
                        // La forma base o preevolución
                        let previousImage = evolutions[index - 1].image
                        
                        HStack(spacing: 20) {
                            // Imagen de la preevolución
                            Image(previousImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            
                            // Texto del nivel
                            Text("Level \(currentEvolution.level)")
                                .font(.headline)
                                .foregroundColor(getBackgroundColor(pokemonType))
                            
                            // Imagen de la evolución
                            Image(currentEvolution.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                        .padding(.horizontal)
                        
                        // Línea divisoria entre evoluciones
                        if index < evolutions.count - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.5))
                                .padding(.top, 10)
                        }
                    }
                }
            }
            .padding()*/
        }
    }
}


