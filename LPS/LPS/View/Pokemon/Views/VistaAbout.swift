import SwiftUI

struct VistaAbout: View {
    let pokemon: Pokemon
    let colorFondo: Color
    let statNameMap: [String: String] = [
        "hp": "HP",
        "attack": "ATK",
        "defense": "DEF",
        "special-attack": "SATK",
        "special-defense": "SDEF",
        "speed": "SPD"
    ]

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
                            
                            HStack(spacing: 2) { // Añade el texto "Kg" junto al número
                                Text("\(Int(pokemon.weight))")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Kg")
                                    .font(.headline)
                                    .bold()
                            }
                            
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
                            
                            HStack(spacing: 2) { // Añade el texto "m" junto al número
                                Text("\(Int(pokemon.height))")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("m")
                                    .font(.headline)
                                    .bold()
                            }
                            
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
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                Divider()
                
                // Estadísticas base
                VStack {
                    // Título centrado
                    Text("Base Stats")
                        .font(.headline)
                        .foregroundColor(colorFondo)
                        .padding(.bottom, 8)

                    ForEach(Array(pokemon.stats.keys).sorted(), id: \.self) { statName in
                        HStack {
                            // Nombre de la estadística mapeado
                            Text(statNameMap[statName.lowercased()] ?? statName.uppercased()) // Usa el mapeo o el nombre original
                                .frame(width: 50, alignment: .leading)
                                .font(.caption)
                                .foregroundColor(colorFondo)

                            // Valor de la estadística alineado a la derecha
                            Text(String(format: "%03d", pokemon.stats[statName] ?? 0)) // Formato "045"
                                .frame(width: 30, alignment: .trailing)
                                .font(.caption)
                                .foregroundColor(.gray)

                            // Barra de progreso
                            ProgressView(
                                value: Double(pokemon.stats[statName] ?? 0),
                                total: 200.0 // Cambia este valor según el máximo esperado
                            )
                            .progressViewStyle(LinearProgressViewStyle(tint: colorFondo))
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal) // Espaciado lateral
                }

            }
            .padding()
        }
    }
}

 
