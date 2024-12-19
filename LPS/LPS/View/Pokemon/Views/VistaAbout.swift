import SwiftUI

struct VistaAbout: View {
    var pokemon: Pokemon
    var getBackgroundColor: (String) -> Color

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                // Peso y Altura con más separación
                HStack(alignment: .center, spacing: 50) { // Incrementamos el spacing aquí
                    // Peso
                    VStack {
                        Image(systemName: "scalemass")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        Text("\(pokemon.weight)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Weight")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Separador vertical
                    Divider()
                        .frame(height: 40)
                        .background(Color.gray)
                    
                    // Altura
                    VStack {
                        Image(systemName: "ruler")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        Text("\(pokemon.height)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Height")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity) // Asegura que el contenido ocupe el ancho disponible
                
                Divider()
                
                // Descripción
                Text(pokemon.description)
                    .font(.body)
                    .padding(.top, 10)
                
                Divider()
                
                // Estadísticas base
                VStack(alignment: .leading, spacing: 10) {
                    Text("Base Stats")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    ForEach(pokemon.stats.keys.sorted(), id: \.self) { statName in
                        HStack {
                            Text(statName)
                                .frame(width: 50, alignment: .leading)
                                .font(.caption)
                            ProgressView(value: Double(pokemon.stats[statName] ?? 0), total: 200.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: getBackgroundColor(pokemon.types[0])))
                                .frame(maxWidth: .infinity)
                            Text("\(pokemon.stats[statName] ?? 0)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

 
