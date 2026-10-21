//
//  Favorites.swift
//  Explore Indonesia
//
//  The places saved with the heart button. They are stored on the device,
//  so they are still there after the app is closed.
//

import Foundation
import Observation

@Observable
class Favorites {
    /// The one shared list, used by every screen.
    static let shared = Favorites()

    /// The ids of the saved places, for example ["borobudur", "ubud"].
    var ids: [String] = UserDefaults.standard.stringArray(forKey: "favoriteIds") ?? []

    func contains(_ destination: Destination) -> Bool {
        ids.contains(destination.id)
    }

    /// Saves the place if it isn't saved yet, otherwise removes it.
    func toggle(_ destination: Destination) {
        if contains(destination) {
            ids.removeAll { $0 == destination.id }
        } else {
            ids.append(destination.id)
        }
        UserDefaults.standard.set(ids, forKey: "favoriteIds")
    }
}
