//
//  HeaderView.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

struct BusquedaView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Buscar...")
                        .foregroundColor(Color.gray)
                }
                TextField("", text: $text)
                    .frame(height: 8)
            }
            
        }
        .padding()
        .frame(width: 325, height: 40)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black.opacity(0.5), lineWidth: 2)
        )
    
    }
}

struct HeaderView: View {
    @State var query: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("Hi! Stanley 👋")
                    .font(.system(size: 34))
                    .fontWeight(.medium)
                    .offset(x: -80)
            }

            HStack {
                BusquedaView(text: $query)
                Button {

                } label: {
                    Image(systemName: 1 == 1 ? "heart" : "heart.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
                
            }

        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
