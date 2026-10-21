//
//  Explore_IndonesiaApp.swift
//  Explore Indonesia
//
//  Created by Jessi Febria on 16/10/26.
//

import SwiftUI

@main
struct Explore_IndonesiaApp: App {
    /// Defaults to ON so the App Store build opens in the accessible version.
    @AppStorage("accessibilityFixEnabled") private var fix = true

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.a11yFix, fix)
        }
    }
}
