import SwiftUI

struct VistaDetalle: View {
    let pokemon : Pokemon
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedTab: Tab = .about
    @State private var isShiny: Bool = false
    @State private var favorite: Bool = false

    var body: some View {
        ZStack {
            // Fondo verde que cubre toda la pantalla
            Color(viewModel.getColor(pokemon.types.first))
                .edgesIgnoringSafeArea(.all)
            
            HStack{
                Spacer()
                    .frame(width: 140)
                Image("poke")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 5)
            }
            .zIndex(-1)
            .padding(.top, -440)
          
            VStack(spacing: 0) {
                //Cabecera
                HStack {
                    
                    Spacer()
                        .frame(width: 20)
                    
                    //Flecha de volver al menú
                    Button(action: {
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    //Nombre
                    Text(pokemon.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
        
                    //Botón shiny
                    Button(action: {
                        isShiny.toggle()
                    }) {
                        Text("Shiny")
                            .padding(6)
                            .background(isShiny ? Color.orange : Color.gray)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                    //TagPokemon
                    Text("#\(pokemon.id)")
                        .font(.body)
                        .foregroundColor(.white)
                    //Botón Favorito
                    Button(action: {
                        favorite.toggle()
                    }) {
                        Image(systemName: favorite ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                        .frame(width: 20)
                }
                
                .zIndex(2)
                ZStack {
                    // Rectángulo blanco
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                        .padding(.top, 240)
                    
                    // Contenido de las tabs dinámicas
                    TabContent(selectedTab: $selectedTab, pokemon: pokemon)
                        .padding(.top, 380)
                }
                .zIndex(1) 
            }

            // Flechas de navegación y Pokémon imagen ARREGLAR FLECHAS
            HStack {
                Button(action: {})
                {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white)
                        .frame(width: 35, height: 35)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                .offset(x: -40)

                (isShiny ? pokemon.image : pokemon.image_shiny)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 210)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)

                Button(action: {})
                {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white)
                        .frame(width: 35, height: 35)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                .offset(x: 40)
            }
            .offset(y: -160)
            .zIndex(3) // Sobre todo el contenido
            
            HStack {
                //Muestra el tipo del pokemon
                ForEach(pokemon.types, id: \.self) { type in
                    Text(type)
                        .padding(4)
                        .background(Color(viewModel.getColor(pokemon.types.first)))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                }
            }
            .offset(y: -40)
            
            HStack {
                TabButton(
                    title: "About",
                    isSelected: selectedTab == .about,
                    action: { selectedTab = .about },
                    viewModel: viewModel
                )
                TabButton(
                    title: "Evolutions",
                    isSelected: selectedTab == .evolutions,
                    action: { selectedTab = .evolutions },
                    viewModel: viewModel
                )
                TabButton(
                    title: "Moves",
                    isSelected: selectedTab == .moves,
                    action: { selectedTab = .moves },
                    viewModel: viewModel 
                )
            }

        }
    }
}

// Botón de tab reutilizable
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(Color(viewModel.getColor(pokemon.types.first)))
                .underline(isSelected, color: viewModel.getColor(pokemon.types.first)))
                .padding(.horizontal)
        }
    }
}

enum Tab {
    case about, evolutions, moves
}


// Contenido dinámico de las tabs
struct TabContent: View {
    @Binding var selectedTab: Tab
    let pokemon: Pokemon

    var body: some View {
        VStack {
            switch selectedTab {
            case .about:
                VistaAbout(pokemon: pokemon, getColor: getColor)
            case .evolutions:
                VistaEvolution(evolutions: pokemon.evolution_chain_id, getColor: getColor, pokemonType: pokemon.types.first ?? "Normal")
            case .moves:
                VistaMovimientos(moves: pokemon.moves,
                                 getColor: getColor, pokemonType: pokemon.types.first ?? "Normal")
            }
        }
    }
}





