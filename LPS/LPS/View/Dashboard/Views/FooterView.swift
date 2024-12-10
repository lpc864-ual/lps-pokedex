//
//  FooterView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct FooterView: View {
    var username: String
    var body: some View {
        HStack(spacing: 80) {
            // Boton de batallas
            Button(action: {
                
            }) {
                Image("battles")
                    .resizable()
                    .frame(width: 61, height: 65)

            }
            
            // Boton de menu
            Button(action: {
                
            }) {
                Image("pokeball")
                    .resizable()
                    .frame(width: 61, height: 65)
            }
            // Boton de perfil
            Button(action: {
                
            }) {
                Image("profile")
                    .resizable()
                    .frame(width: 61, height: 65)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 239.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0))
        
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(username: "")
    }
}
