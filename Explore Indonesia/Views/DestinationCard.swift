//
//  DestinationCard.swift
//  Explore Indonesia
//
//  A small card with a photo, name, region and budget. Tapping it opens Detail.
//  Used on Home and Favorites.
//
//  The whole card is written twice:
//    if fix { … }   the accessible version
//    else   { … }   the version with the bugs
//

import SwiftUI

struct DestinationCard: View {
    let destination: Destination

    @Environment(\.a11yFix) private var fix
    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        if fix {
            VStack(alignment: .leading, spacing: 6) {
                // A grey box with the photo on top. The photo downloads from its URL.
                Color.gray.opacity(0.2)
                    .frame(height: textSize.isAccessibilitySize ? 160 : 96)
                    .overlay {
                        AsyncImage(url: destination.photos[0].url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        // A11Y FIX: VoiceOver – the photo is described, not skipped
                        .accessibilityHidden(false)
                        .accessibilityLabel(destination.photos[0].altText)
                    }
                    .clipShape(.rect(cornerRadius: 8))

                Text(destination.name)
                    // A11Y FIX: Larger Text – a text style that grows; long names wrap onto more lines
                    .font(.headline)
                    // A11Y FIX: VoiceOver – the name is read first, before the photo
                    .accessibilitySortPriority(1)

                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        // A11Y FIX: VoiceOver – the pin is decoration, the region text says it all
                        .accessibilityHidden(true)
                    Text(destination.region)
                }
                .font(.footnote)
                // A11Y FIX: Sufficient Contrast – a dark enough grey
                .foregroundStyle(Color.secondary)

                Spacer(minLength: 0)

                BudgetView(level: destination.budget)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            // A11Y FIX: Dark Interface – system colors that turn dark in Dark Mode
            .foregroundStyle(Color.primary)
            .background(Color(.secondarySystemBackground))
            .clipShape(.rect(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray4), lineWidth: 2))
            .onTapGesture {
                AppNavigation.shared.path.append(destination)
            }
            // A11Y FIX: VoiceOver – the whole card is read as one button:
            // "Borobudur, <photo description>, Central Java, Price level: 1 out of 3, Button"
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)

        } else {
            VStack(alignment: .leading, spacing: 6) {
                // The photo downloads from its URL.
                // Bug: no description, so VoiceOver can't say what's in the photo
                AsyncImage(url: destination.photos[0].url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 96)
                .clipShape(.rect(cornerRadius: 8))

                Text(destination.name)
                    // Bug: fixed 15 pt that never grows, and long names are cut off with "…"
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)

                HStack {
                    // Bug: VoiceOver reads the pin icon as its own element
                    Image(systemName: "mappin.and.ellipse")
                    Text(destination.region)
                        .lineLimit(1)
                        // Bug: light grey #AAAAAA on white is too faint to read
                        .foregroundStyle(Color(white: 0.7))
                }
                // Bug: fixed 11 pt, for the pin and the region, that never grows
                .font(.system(size: 11))

                Spacer()

                BudgetView(level: destination.budget)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            // Bug: always black text on white, even in Dark Mode
            .foregroundStyle(Color.black)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(.systemGray4), lineWidth: 2))
            // Bug: a tap gesture with no button trait. VoiceOver doesn't know the card is a button,
            // so it reads each piece on its own: photo, name, pin, region, each dollar sign.
            .onTapGesture {
                AppNavigation.shared.path.append(destination)
            }
        }
    }
}

#Preview("Fix off") {
    NavigationStack { DestinationCard(destination: Destination.all[1]).frame(width: 175) }
        .environment(\.a11yFix, false)
}

#Preview("Fix on") {
    NavigationStack { DestinationCard(destination: Destination.all[1]).frame(width: 175) }
        .environment(\.a11yFix, true)
}
