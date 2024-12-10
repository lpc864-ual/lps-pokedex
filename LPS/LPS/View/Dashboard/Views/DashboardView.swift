//  DashboardView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

//
//  CardView.swift
//  LPS
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

struct DashboardView: View {
    var username: String
    @State var backend = CoreDataManager()
    @State private var evolutions: [(Pokemon, String, Pokemon)] = []
    
    var body: some View {
        VStack {
            HeaderView(username: username)
            CardView(name: "bulbasur", username: username)
            Spacer()
            FooterView(username: username)
        }
        .navigationBarBackButtonHidden(true)
        .task {
            evolutions = await backend.loadEvolutions(evolution_chain_id: 1)
            print(evolutions)
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(username: "")
    }
}
