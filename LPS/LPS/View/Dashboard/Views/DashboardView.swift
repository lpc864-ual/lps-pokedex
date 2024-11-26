//
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
    var body: some View {
        VStack {
            HeaderView()
            CardView(name: "Bulbasur", imageName: "bulbasur")
            Spacer()
            FooterView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
