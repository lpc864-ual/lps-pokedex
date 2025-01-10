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
