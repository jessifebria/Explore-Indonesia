//
//  AppNavigation.swift
//  Explore Indonesia
//
//  The selected tab, and the list of screens opened on top of each tab.
//  Adding a destination to `path` opens its Detail screen in the current tab; removing it goes back.
//
//  The cards open Detail with .onTapGesture, which adds the place to this list.
//  The fixed cards also tell VoiceOver they are buttons (see DestinationCard).
//

import Observation

/// The three tabs at the bottom of the screen.
enum AppTab: Hashable {
    case home, favorites, settings
}

@Observable
class AppNavigation {
    /// The one shared navigation, used by every screen.
    static let shared = AppNavigation()

    var selectedTab: AppTab = .home

    /// Each tab keeps its own list, so switching tabs doesn't open the same Detail everywhere.
    var homePath: [Destination] = []
    var favoritesPath: [Destination] = []

    /// The list of the tab that is showing right now.
    var path: [Destination] {
        get { selectedTab == .favorites ? favoritesPath : homePath }
        set {
            if selectedTab == .favorites {
                favoritesPath = newValue
            } else {
                homePath = newValue
            }
        }
    }
}
