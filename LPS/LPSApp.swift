//
//  LPSApp.swift
//  LPS
//
//  Created by Aula03 on 12/11/24.
//

import SwiftUI

@main
struct LPSApp: App {
    var body: some Scene {
        @StateObject var vm: ViewModel = ViewModel()
        WindowGroup {
            SignInView()
                .environmentObject(vm)
        }
    }
}
