import SwiftUI

struct VistaMovimientos: View {
    let pokemon_id: Int
    let colorFondo: Color
    @State private var move_names: [String] = []
    @State private var moves: [Move] = []
    @State private var move_offset: Int = 0
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading moves...")
                    .padding()
            } else if moves.isEmpty {
                Text("There are no moves")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(Array(moves.enumerated()), id: \.offset) { index, move in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(move.name)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(colorFondo)
                                
                                Spacer()
                                
                                HStack(spacing: 10) {
                                    Image(systemName: "scope")
                                        .foregroundColor(.black.opacity(0.7))
                                    Text("\(move.accuracy)%")
                                        .foregroundColor(.black)
                                    
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow.opacity(0.7))
                                    Text("\(move.power)")
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Text(move.description)
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(colorFondo.opacity(0.5), lineWidth: 1.5))
                        .padding(.horizontal)
                        .onAppear {
                            if index >= moves.count - 1 {
                                Task {
                                    moves += await ViewModel.instance.loadMoreMoves(
                                        currentMoves: moves,
                                        moveNames: move_names,
                                        offset: move_offset,
                                        limit: 10
                                    )
                                    move_offset = moves.count
                                }
                            }
                        }
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding(.top, 10)
        .task {
            move_names = await ViewModel.instance.loadMoves(pokemon_id: pokemon_id)
            moves = await ViewModel.instance.loadMoreMoves(currentMoves: [], moveNames: move_names, offset: move_offset, limit: 10)
            move_offset = moves.count
            isLoading = false
        }
    }
}
