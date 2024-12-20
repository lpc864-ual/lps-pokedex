import SwiftUI

struct VistaEvolution: View {
    //var viewmodel: ViewModel
    var evolutions: Int // Evolution Chain ID
    var colorFondo: Color

    @State private var evolutionData: [(Pokemon, String, Pokemon)] = [] // Datos procesados de evoluciones
    @State private var isLoading = true // Para mostrar un indicador de carga

    var body: some View {
        ScrollView {
            if isLoading {
                // Indicador de carga mientras se procesan las evoluciones
                ProgressView("Cargando evoluciones...")
                    .padding()
            } else if evolutionData.isEmpty {
                // Mensaje si no hay evoluciones
                Text("Pokemon sin evolución")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(spacing: 20) {
                    ForEach(evolutionData.indices, id: \.self) { index in
                        let (pokemon1, level, pokemon2) = evolutionData[index]

                        HStack(spacing: 20) {
                            // Imagen del Pokémon base
                            pokemon1.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)

                            // Nivel de evolución
                            Text(level)
                                .font(.headline)
                                .foregroundColor(colorFondo)

                            // Imagen del Pokémon evolucionado
                            pokemon2.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                        .padding(.horizontal)

                        // Línea divisoria entre evoluciones
                        if index < evolutionData.count - 1 {
                            Divider()
                                .background(Color.gray.opacity(0.5))
                                .padding(.top, 10)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                //await fetchEvolutions()
            }
        }
    }

    // Método para cargar las evoluciones usando el ViewModel
    /*private func fetchEvolutions() async {
        isLoading = true
        evolutionData = await viewmodel.loadEvolutions(evolution_chain_id: evolutions)
        isLoading = false
    }*/
}




