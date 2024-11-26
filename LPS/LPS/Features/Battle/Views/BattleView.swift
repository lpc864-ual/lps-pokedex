//
//  HealthView.swift
//  LPS
//
//  Created by Aula03 on 26/11/24.
//

import SwiftUI

struct BattleView: View {
    @State private var rivalHP: CGFloat = 500 // Vida actual del rival
    private let rivalTotalHP: CGFloat = 1000   // Vida total del rival
    
    @State private var playerHP: CGFloat = 500 // Vida actual del jugador
    private let playerTotalHP: CGFloat = 1000   // Vida total del jugador

    var body: some View {
        ZStack {
            // Imagen de fondo
            Image("battleBackground")
                .resizable()
                .scaledToFill()

            VStack {
                // Vida rival (arriba izquierda)
                HStack {
                    VStack(alignment: .leading) {
                        // Fondo blanco para el cuadro
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 80)
                            .overlay(
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("RIVAL TEAM")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    ZStack(alignment: .leading) {
                                        // Fondo de la barra
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)

                                        // Barra de vida
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green)
                                            .frame(width: CGFloat(rivalHP / rivalTotalHP) * 200, height: 10)
                                    }

                                    HStack {
                                        
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.gray.opacity(0.8))
                                            .frame(width: 30, height: 15)
                                            .overlay(
                                                Text("HP")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            )
                                        
                                        Text("\(Int(rivalHP))/\(Int(rivalTotalHP))")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(.horizontal, 10)
                            )
                    }
                    .padding()
                    Spacer()
                }
                Spacer()

                // Vida jugador (abajo derecha)
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        // Fondo blanco para el cuadro
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 80)
                            .overlay(
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("MY TEAM")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    ZStack(alignment: .leading) {
                                        // Fondo de la barra
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)

                                        // Barra de vida
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green)
                                            .frame(width: CGFloat(playerHP / playerTotalHP) * 200, height: 10)
                                    }

                                    HStack {
                                        Text("\(Int(playerHP))/\(Int(playerTotalHP))")
                                            .font(.caption)
                                            .foregroundColor(.black)

                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.gray.opacity(0.8))
                                            .frame(width: 30, height: 15)
                                            .overlay(
                                                Text("HP")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            )
                                    }
                                }
                                .padding(.horizontal, 10)
                            )
                    }
                    .padding()
                }
            }
            
            // Botón de salir (esquina inferior izquierda)
                        VStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    print("Salir de la pelea") // Aquí puedes reemplazar la acción con navegación o cierre
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.left")
                                            .font(.system(size: 20, weight: .bold))
                                        Text("LEAVE")
                                            .font(.headline)
                                    }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(hue: 0.033, saturation: 1.0, brightness: 1.0))
                                    .cornerRadius(10)
                                }
                                .padding(.leading, 10) // Separación del borde izquierdo
                                Spacer()
                            }
                        }
                        .padding(.bottom, 10.0)
        }
    }
}

#Preview {
    BattleView()
}
