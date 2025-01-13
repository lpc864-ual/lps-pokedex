import UIKit
import SwiftUI

// GUILLERMO: Usar TeamsData y acceder a sus valores
// Que por defecto cambie a posicion horizontal automaticamente
// Junto con Alberto conseguir lo de las compilaciones separadas para el listado de pokemones y batalla (usar target: cualquier cosa preguntar a Luis o a Pablo)
// Hacer presentacion ppt (un par de capturas de pantalla del proceso realizado. Cualquier duda preguntar a Luis)

struct BattleView: View {
    @State private var rivalHP: CGFloat = 1000
    private let rivalTotalHP: CGFloat = 1000
    @State private var playerHP: CGFloat = 1000
    private let playerTotalHP: CGFloat = 1000
    @State private var showLeaveAlert: Bool = false
    @State private var combatText: String = "The battle begins!"
    @State private var isPlayerTurn: Bool = true
    @State private var currentPhase: Int = 1
    @State private var isBattleActive: Bool = true
    
    @State private var isLeaveConfirm = false
    
    // Accedemos a los equipos desde TeamsData
    var playerTeam: [Pokemon] = TeamsData.playerTeam
    
    var rivalTeam: [Pokemon] = TeamsData.rivalTeam
    

    var body: some View {
        ZStack {
            // Fondo negro para los laterales en modo horizontal
            Color.black
                .edgesIgnoringSafeArea(.all)

            // Imagen de fondo
            Image("battleBackground")
                .resizable()
                .scaledToFill()

            VStack(alignment: .leading) {
                
                HStack(){
                    // Vida rival (parte superior izquierda)
                    VStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 80)
                            .overlay(
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("RIVAL TEAM")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)
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
                                        
                                        if (rivalHP >= 0){
                                            Text("\(Int(rivalHP))/\(Int(playerTotalHP))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }else{
                                            Text("\(Int(0))/\(Int(playerTotalHP))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding(.horizontal, 10)
                            )
                        
                        // Botón de salir
                        Button(action: {
                            showLeaveAlert = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 25, weight: .bold))
                                Text("LEAVE")
                                    .font(.headline)
                            }
                            .frame(width: 100, height: 10.0)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 40.0)
                    .padding(.leading, 10.0)
                    
                    Spacer()
                    
                    VStack{
                        Spacer()
                        HStack{
                            ForEach(rivalTeam, id: \.id) { pokemon in
                                pokemon.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50) // Ajusta el tamaño según lo necesites
                            }
                        }
                    }.padding(.trailing, 10.0)
                    
                }
        
                HStack {
                    
                    HStack{
                        // Usar las imágenes de los Pokémon del equipo del jugador
                        ForEach(playerTeam, id: \.id) { pokemon in
                            pokemon.image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50) // Ajusta el tamaño según lo necesites
                        }

                    }
                    .padding(.leading)
                    
                    Spacer()

                    // Vida jugador
                    VStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(width: 250, height: 80)
                            .overlay(
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("MY TEAM")
                                        .font(.headline)
                                        .foregroundColor(.black)

                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green)
                                            .frame(width: CGFloat(playerHP / playerTotalHP) * 200, height: 10)
                                    }

                                    HStack {
                                        if (playerHP >= 0){
                                            Text("\(Int(playerHP))/\(Int(playerTotalHP))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }else{
                                            Text("\(Int(0))/\(Int(playerTotalHP))")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }


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
                    .padding(.trailing, 10.0)
                }

                // Texto del combate con "Tap to continue"
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.7))
                    .frame(height: 100)
                    .overlay(
                        VStack() {
                                Text(combatText)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                            
                                Text("Tap to continue")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                                
                        }
                    )
                    .onTapGesture {
                        if isBattleActive {
                            performBattlePhase()
                        }else{
                            isLeaveConfirm = true
                        }
                    }
            }
            
            .alert("Leave Battle", isPresented: $showLeaveAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm", role: .destructive) {
                    isLeaveConfirm = true
                    print("El usuario ha confirmado salir de la batalla.")
                }
            } message: {
                Text("Are you sure you want to leave the battle?")
            }
            
            NavigationLink(
                destination: MenuView(),
                isActive: $isLeaveConfirm,
                label: { EmptyView() }
            )
        }
    }

    // Realiza una fase de combate (ataque de jugador o rival)
    private func performBattlePhase() {
        guard isBattleActive else { return }
        
        //AQUI SE DEBE TOMAR LOS VALORES DE AMBOS EQUIPOS PARA EL DAÑO Y LA PROBABILIDAD
        
        let damage = Int.random(in: 0...100) <= 85 ? 90 : 0 // 85% de probabilidad de acierto
        if currentPhase == 1 {
            if damage > 0 {
                rivalHP -= CGFloat(damage)
                combatText = "Your team attacks and deals \(damage) damage!"
            } else {
                combatText = "Your team attacks, but misses!"
            }
            currentPhase = 2
        } else {
            if damage > 0 {
                playerHP -= CGFloat(damage)
                combatText = "The rival team attacks and deals \(damage) damage!"
            } else {
                combatText = "The rival team attacks, but misses!"
            }
            currentPhase = 1
        }
        
        // Verifica si alguien ha ganado
        if rivalHP <= 0 {
            combatText = "You won the battle!"
            isBattleActive = false
        } else if playerHP <= 0 {
            combatText = "You lost the battle!"
            isBattleActive = false
        }
    }
}

struct BattleView_Previews: PreviewProvider {
    static var previews: some View {
        BattleView()
    }
}
