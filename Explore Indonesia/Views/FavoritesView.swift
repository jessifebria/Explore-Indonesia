//
//  FavoritesView.swift
//  Explore Indonesia
//
//  The places saved with the heart button, in the same cards as Home.
//
//  The whole screen is written twice:
//    if fix { … }   the accessible version
//    else   { … }   the version with the bugs
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.a11yFix) private var fix
    @Environment(\.dynamicTypeSize) private var textSize
    private let favorites = Favorites.shared

    var body: some View {
        let savedPlaces = Destination.all.filter { favorites.contains($0) }

        if fix {
            ScrollView {
                if savedPlaces.isEmpty {
                    VStack(spacing: 8) {
                        // A11Y FIX: Larger Text – text styles that grow
                        Text("No favorites yet")
                            .font(.headline)
                        Text("Tap the heart on a destination to save it here.")
                            .font(.subheadline)
                            // A11Y FIX: Sufficient Contrast – a dark enough grey
                            .foregroundStyle(Color.secondary)
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity)
                } else {
                    // A11Y FIX: Larger Text – 1 column at the largest text sizes, so cards have room
                    LazyVGrid(columns: textSize.isAccessibilitySize ? [GridItem()] : [GridItem(), GridItem()], spacing: 12) {
                        ForEach(savedPlaces) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            // A11Y FIX: Dark Interface – system colors that turn dark in Dark Mode
            .foregroundStyle(Color.primary)
            .background(Color(.systemBackground))
            .navigationTitle("Favorites")

        } else {
            ScrollView {
                if savedPlaces.isEmpty {
                    VStack(spacing: 8) {
                        // Bug: fixed sizes that never grow
                        Text("No favorites yet")
                            .font(.system(size: 17, weight: .bold))
                        Text("Tap the heart on a destination to save it here.")
                            .font(.system(size: 13))
                            // Bug: light grey #AAAAAA on white is too faint to read
                            .foregroundStyle(Color(white: 0.67))
                    }
                    .padding(.top, 80)
                    .frame(maxWidth: .infinity)
                } else {
                    // Bug: always 2 columns, even when the text is huge
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 12) {
                        ForEach(savedPlaces) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            // Bug: always black on white, even in Dark Mode
            .foregroundStyle(Color.black)
            .background(Color.white)
            .navigationTitle("Favorites")
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

#Preview {
    NavigationStack { FavoritesView() }
}
