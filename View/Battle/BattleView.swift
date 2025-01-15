import UIKit
import SwiftUI

struct BattleView: View {
    var playerTeam: [Pokemon]
    var rivalTeam: [Pokemon]
    @State private var playerHP: Int = 1000
    private let playerTotalHP: Int = 1000
    private var playerPowerSum: Int {
            playerTeam.reduce(0) { sum, pokemon in
                sum + (pokemon.move?.power ?? 0)
            }
        }
    private var playerAccuracyAvg: CGFloat {
            let totalAccuracy = playerTeam.reduce(0) { sum, pokemon in
                sum + (pokemon.move?.accuracy ?? 0)
            }
            let moveCount = playerTeam.filter { $0.move?.accuracy != nil }.count
            return moveCount > 0 ? CGFloat(totalAccuracy) / CGFloat(moveCount) : 0.0
        }
    
    @State private var rivalHP: Int = 1000
    private let rivalTotalHP: Int = 1000
    private var rivalPowerSum: Int {
            rivalTeam.reduce(0) { sum, pokemon in
                sum + (pokemon.move?.power ?? 0)
            }
        }
    private var rivalAccuracyAvg: CGFloat {
            let totalAccuracy = rivalTeam.reduce(0) { sum, pokemon in
                sum + (pokemon.move?.accuracy ?? 0)
            }
            let moveCount = rivalTeam.filter { $0.move?.accuracy != nil }.count
            return moveCount > 0 ? CGFloat(totalAccuracy) / CGFloat(moveCount) : 0.0
        }
    
    @State private var showLeaveAlert: Bool = false
    @State private var combatText: String = "The battle begins!"
    @State private var isPlayerTurn: Bool = true
    @State private var currentPhase: Int = 1
    @State private var isBattleActive: Bool = true
    
    @State private var isLeaveConfirm = false

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

                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 10)  //Barra de fondo vida rival
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)
                                        RoundedRectangle(cornerRadius: 10)  //Barra vida rival
                                            .fill(Color.green)
                                            .frame(width: CGFloat(CGFloat(rivalHP) / CGFloat(rivalTotalHP)) * 200, height: 10)
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
                        HStack{
                            //Muestra imagenes del equipo rival
                            ForEach(rivalTeam, id: \.id) { pokemon in
                                pokemon.image
                                    .resizable()
                                    .frame(width: 100, height: 100) // Ajusta el tamaño de los pokemon
                            }
                        }
                    }
                    .padding(.trailing, 20.0)
                    .padding(.top, 100.0)
                    
                }
        
                HStack {
                    HStack{
                        // Muestra imagenes del equipo jugador
                        ForEach(playerTeam, id: \.id) { pokemon in
                            pokemon.image
                                .resizable()
                                .frame(width: 100, height: 100) // Ajusta el tamaño de los pokemon
                        }
                    }
                    .padding(.leading)
                    .padding(.bottom, 10)
                    
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

                                    ZStack (alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 10)  //Barra fondo vida Jugador
                                            .fill(Color.green.opacity(0.3))
                                            .frame(width: 200, height: 10)
                                        RoundedRectangle(cornerRadius: 10)  //Barra vida Jugador
                                            .fill(Color.green)
                                            .frame(width: CGFloat(CGFloat(playerHP) / CGFloat(playerTotalHP)) * 200, height: 10)
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
                                    .offset(x:320, y:-30)
                                
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
        
        let accuracyCheck = CGFloat.random(in: 0...100)
        
        if currentPhase == 1 {
            // Turno del jugador
            if accuracyCheck <= playerAccuracyAvg {
                rivalHP -= playerPowerSum
                combatText = "Your team attacks and deals \(playerPowerSum) damage!"
            } else {
                combatText = "Your team attacks, but misses!"
            }
            currentPhase = 2
        } else {
            // Turno del rival
            if accuracyCheck <= rivalAccuracyAvg {
                playerHP -= rivalPowerSum
                combatText = "The rival team attacks and deals \(rivalPowerSum) damage!"
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
        BattleView(playerTeam: [], rivalTeam: [])
    }
}
