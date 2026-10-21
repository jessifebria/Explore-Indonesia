//
//  HomeView.swift
//  Explore Indonesia
//
//  The first screen: a fun fact about Indonesia, then a grid of recommendations.
//
//  The whole screen is written twice:
//    if fix { … }   the accessible version
//    else   { … }   the version with the bugs
//

import SwiftUI

struct HomeView: View {
    @Environment(\.a11yFix) private var fix
    @Environment(\.dynamicTypeSize) private var textSize
    @State private var fact = funFacts[0]

    var body: some View {
        content
            // A new random fact every time Home appears
            .onAppear { fact = funFacts.randomElement()! }
    }

    @ViewBuilder
    private var content: some View {
        if fix {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    FunFactCard(fact: fact)

                    Text("The top recommendations")
                        .font(.headline)
                        // A11Y FIX: VoiceOver – a heading, so the rotor can jump straight to it
                        .accessibilityAddTraits(.isHeader)

                    // A11Y FIX: Larger Text – 1 column at the largest text sizes, so cards have room
                    LazyVGrid(columns: textSize.isAccessibilitySize ? [GridItem()] : [GridItem(), GridItem()], spacing: 12) {
                        ForEach(Destination.recommendations) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            // A11Y FIX: Dark Interface – system colors that turn dark in Dark Mode
            .foregroundStyle(Color.primary)
            .background(Color(.systemBackground))
            .navigationTitle("Wisata Nusantara")

        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    FunFactCard(fact: fact)

                    // Bug: looks like a heading, but VoiceOver reads it as plain text
                    Text("The top recommendations")
                        .font(.system(size: 17, weight: .bold))

                    // Bug: always 2 columns, even when the text is huge
                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 12) {
                        ForEach(Destination.recommendations) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            // Bug: always black on white, even in Dark Mode
            .foregroundStyle(Color.black)
            .background(Color.white)
            .navigationTitle("Wisata Nusantara")
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

private let funFacts = [
    // The country
    "Indonesia has more than 17,000 islands, making it the world's largest island country.",
    "From east to west, Indonesia is wider than the mainland United States.",
    "People in Indonesia speak over 700 languages, and one shared language, Bahasa Indonesia.",
    "Indonesia's motto, Bhinneka Tunggal Ika, means \"Unity in Diversity\".",
    "Indonesia covers 3 time zones.",

    // Only in Indonesia
    "Komodo dragons, the world's largest lizards, live in the wild only in Indonesia.",
    "The last wild Javan rhinos live only in Ujung Kulon National Park.",
    "Borobudur is the largest Buddhist temple in the world.",
    "Among the Minangkabau of West Sumatra, family homes and land pass down from mother to daughter.",

    // Traditions
    "On Nyepi, Bali's Day of Silence, the whole island goes quiet and even the airport closes for 24 hours.",
    "The night before Nyepi, Balinese villages parade giant monster statues called ogoh-ogoh.",
    "Every Eid, millions of Indonesians travel home in a tradition called mudik.",
    "Wayang kulit shadow puppet shows can last all night, from evening until dawn.",
    "In the Saman dance from Aceh, dancers clap and move so fast it's called the dance of a thousand hands.",
    "In Bali's Kecak dance, dozens of men chant \"cak\" together instead of playing instruments.",
    "In West Sumatra's Pacu Jawi, riders race through muddy rice fields holding on to the tails of 2 bulls.",
    "Indonesian batik is on UNESCO's list of world cultural heritage, and October 2 is National Batik Day.",
    "Minangkabau houses have roofs that curve up like buffalo horns.",
]

/// A small "Did you know?" card. It isn't a button, so it has nothing to tap.
struct FunFactCard: View {
    let fact: String

    @Environment(\.a11yFix) private var fix

    var body: some View {
        if fix {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    // A11Y FIX: Larger Text – text styles that grow
                    .font(.title3)
                    .foregroundStyle(.purple)
                    // A11Y FIX: VoiceOver – the bulb is decoration, so it's skipped
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Did you know?")
                        .font(.headline)
                    Text(fact)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.05), in: .rect(cornerRadius: 16))
            // A11Y FIX: VoiceOver – title and fact are read together in one swipe:
            // "Did you know?, Indonesia has more than 17,000 islands…"
            .accessibilityElement(children: .combine)

        } else {
            HStack(alignment: .top, spacing: 12) {
                // Bug: VoiceOver stops on the bulb and reads "Lightbulb"
                Image(systemName: "lightbulb.fill")
                    // Bug: fixed sizes that never grow
                    .font(.system(size: 20))
                    .foregroundStyle(.purple)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Did you know?")
                        .font(.system(size: 17, weight: .semibold))
                    Text(fact)
                        .font(.system(size: 17))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.purple.opacity(0.05), in: .rect(cornerRadius: 16))
            // Bug: bulb, title and fact are 3 separate stops for VoiceOver
        }
    }
}

#Preview("Fix off") {
    NavigationStack { HomeView() }.environment(\.a11yFix, false)
}

#Preview("Fix on") {
    NavigationStack { HomeView() }.environment(\.a11yFix, true)
}

#Preview("Fix off – Dark") {
    NavigationStack { HomeView() }.environment(\.a11yFix, false).preferredColorScheme(.dark)
}

#Preview("Fix on – Dark") {
    NavigationStack { HomeView() }.environment(\.a11yFix, true).preferredColorScheme(.dark)
}

#Preview("Fix off – Large text") {
    NavigationStack { HomeView() }.environment(\.a11yFix, false).dynamicTypeSize(.accessibility3)
}

#Preview("Fix on – Large text") {
    NavigationStack { HomeView() }.environment(\.a11yFix, true).dynamicTypeSize(.accessibility3)
}
