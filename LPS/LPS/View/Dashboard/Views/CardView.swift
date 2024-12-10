//
//  CardView.swift
//  LPS
//
//  Created by Aula03 on 19/11/24.
//

import SwiftUI

struct CardView: View {
    var name: String
    var username: String
    var body: some View {

        VStack {
            HStack {
                Text(name)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("#001")
                    .foregroundStyle(.black.opacity(0.4))
            }
            
            HStack {
                VStack{
                    Text("Grass")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(height: -5)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .offset(x: -5)
                    
                    Text("Poison")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(height: -5)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                ZStack {
                    Image("pokeball_bg")
                    Image("bulbasur")
                }
                .offset(x: 15, y: 15)
                
            }
        }
        .padding()
        .background(.green)
        .cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(name: "bulbasur", username: "")
    }
}
