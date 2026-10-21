//
//  RootView.swift
//  Explore Indonesia
//
//  A system TabView with Home, Favorites and Settings.
//  Each tab has its own NavigationStack, so tapping a place opens Detail inside that tab.
//
//  The tab items are written twice:
//    if fix { … }   the accessible version
//    else   { … }   the version with the bugs
//

import SwiftUI

struct RootView: View {
    @Environment(\.a11yFix) private var fix

    /// The selected tab and the screens opened on top, for example the Detail screen of Borobudur.
    @Bindable private var navigation = AppNavigation.shared

    var body: some View {
        TabView(selection: $navigation.selectedTab) {
            NavigationStack(path: $navigation.homePath) {
                HomeView()
                    .navigationDestination(for: Destination.self) { DetailView(destination: $0) }
            }
            .tabItem {
                if fix {
                    // A11Y FIX: VoiceOver & Voice Control – the tab has a visible name: "Home, tab, 1 of 3"
                    Label("Home", systemImage: "house")
                } else {
                    // Bug: icon only, no name
                    Image(systemName: "house")
                }
            }
            .tag(AppTab.home)

            NavigationStack(path: $navigation.favoritesPath) {
                FavoritesView()
                    .navigationDestination(for: Destination.self) { DetailView(destination: $0) }
            }
            .tabItem {
                if fix {
                    // A11Y FIX: VoiceOver & Voice Control – the tab has a visible name
                    Label("Favorites", systemImage: "heart")
                } else {
                    // Bug: icon only, no name
                    Image(systemName: "heart")
                }
            }
            .tag(AppTab.favorites)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                // Settings keeps its name even in the "before" version,
                // so everyone can always find the switch and turn the fix back on.
                Label("Settings", systemImage: "gearshape")
            }
            .tag(AppTab.settings)
        }
    }
}

#Preview("Fix off") {
    RootView().environment(\.a11yFix, false)
}

#Preview("Fix on") {
    RootView().environment(\.a11yFix, true)
}
