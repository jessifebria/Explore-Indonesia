//
//  DetailView.swift
//  Explore Indonesia
//
//  Everything about one place, from top to bottom:
//  photos, name with the heart button, region and budget, and the info sections.
//
//  The whole screen is written twice:
//    if fix { … }   the accessible version
//    else   { … }   the version with the bugs
//

import Combine
import SwiftUI

struct DetailView: View {
    let destination: Destination

    @Environment(\.a11yFix) private var fix
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var textSize

    /// The photo on screen: 0 = first photo.
    @State private var currentPhoto = 0
    /// Ticks every 3 seconds, to move to the next photo.
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    private let favorites = Favorites.shared
    private let monthLetters = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"]
    private let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var body: some View {
        let isSaved = favorites.contains(destination)

        if fix {
            // For VoiceOver, for example "Best months: Oct, Nov, Dec, Jan, Feb, Mar, Apr"
            let bestMonths = destination.goodMonths.map { monthNames[$0 - 1] }.joined(separator: ", ")

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    // MARK: Photos – swipe left and right; they also move by themselves every 3 seconds

                    TabView(selection: $currentPhoto) {
                        ForEach(0..<destination.photos.count, id: \.self) { index in
                            Color.gray.opacity(0.2)
                                .overlay {
                                    AsyncImage(url: destination.photos[index].url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .clipped()
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page) // swipeable pages with dots at the bottom
                    .indexViewStyle(.page(backgroundDisplayMode: .always)) // a dark pill behind the dots
                    .frame(height: 320)
                    // A11Y FIX: VoiceOver – describes the photo and says "Photo 1 of 3"; swipe up or down to change it
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(destination.photos[currentPhoto].altText)
                    .accessibilityValue("Photo \(currentPhoto + 1) of \(destination.photos.count)")
                    .accessibilityAddTraits(.isImage)
                    .accessibilityAdjustableAction { direction in
                        if direction == .increment {
                            currentPhoto = min(currentPhoto + 1, destination.photos.count - 1)
                        } else {
                            currentPhoto = max(currentPhoto - 1, 0)
                        }
                    }
                    .onReceive(timer) { _ in
                        // A11Y FIX: Reduced Motion – the photos don't move by themselves when Reduce Motion is on
                        if !reduceMotion {
                            withAnimation {
                                currentPhoto = (currentPhoto + 1) % destination.photos.count
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        // MARK: Name and heart button

                        HStack(alignment: .top) {
                            Text(destination.name)
                                // A11Y FIX: Larger Text – a text style that grows
                                .font(.largeTitle.bold())
                                // A11Y FIX: VoiceOver – the place name is a heading
                                .accessibilityAddTraits(.isHeader)

                            Spacer()

                            Button {
                                favorites.toggle(destination)
                            } label: {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundStyle(isSaved ? Color.pink : Color.primary)
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground), in: .circle)
                                    .accessibilityHidden(true)
                            }
                            .buttonStyle(.plain)
                            // A11Y FIX: VoiceOver – the button is called "Favorite" and says "Selected" when saved
                            .accessibilityLabel("Favorite")
                            .accessibilityAddTraits(isSaved ? .isSelected : [])
                            // A11Y FIX: Voice Control – you can say "Tap Favorite", and "Show names" shows its name
                            .accessibilityInputLabels(["Favorite", "Heart", "Save"])
                        }

                        // MARK: Region, tagline and budget

                        // A11Y FIX: Larger Text – region and budget sit side by side,
                        // and move under each other when the text is too big for one line
                        ViewThatFits {
                            HStack(spacing: 12) {
                                regionLabel
                                BudgetView(level: destination.budget)
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                regionLabel
                                BudgetView(level: destination.budget)
                            }
                        }

                        Text(destination.tagline)
                            // A11Y FIX: Larger Text – a text style that grows
                            .font(.subheadline)
                            // A11Y FIX: Sufficient Contrast – a dark enough grey
                            .foregroundStyle(Color.secondary)

                        Divider()

                        // MARK: About

                        Label("About this place", systemImage: "book")
                            // A11Y FIX: Larger Text – a text style that grows
                            .font(.headline)
                            // A11Y FIX: VoiceOver – section titles are headings, so users can jump between them
                            .accessibilityAddTraits(.isHeader)
                            .padding(.top, 8)
                        Text(destination.about)
                            // A11Y FIX: Larger Text – a text style that grows
                            .font(.body)
                            .font(.custom("YourCustomFont", size: 17, relativeTo: .body))

                        // MARK: Best time to visit – one small bar per month

                        Label("Best time to visit", systemImage: "calendar")
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.top, 8)

                        // A11Y FIX: Larger Text – 2 rows of 6 months at the largest text sizes, so they fit on screen
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: textSize.isAccessibilitySize ? 6 : 12), spacing: 10) {
                            ForEach(1...12, id: \.self) { month in
                                let isGood = destination.goodMonths.contains(month)
                                VStack(spacing: 4) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(isGood ? Color.green : Color.red)
                                        .frame(height: textSize.isAccessibilitySize ? 40 : 22)
                                        .overlay {
                                            // A11Y FIX: Differentiate Without Color – a ✓ on good months and an ✗ on bad months
                                            Image(systemName: isGood ? "checkmark" : "xmark")
                                                .font(.caption2.bold())
                                                .foregroundStyle(.white)
                                        }
                                    Text(monthLetters[month - 1])
                                        .font(.caption2)
                                        // A11Y FIX: Sufficient Contrast – a dark enough grey
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        }
                        // A11Y FIX: VoiceOver – one sentence instead of 12 single letters
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Best months: \(bestMonths)")

                        // MARK: Getting there

                        Label("Getting there", systemImage: "airplane")
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.top, 8)
                        Text(destination.gettingThere)
                            .font(.body)

                        // MARK: What to prepare

                        Label("What to prepare", systemImage: "checklist")
                            .font(.headline)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.top, 8)
                        ForEach(destination.prepare, id: \.self) { item in
                            Label(item, systemImage: "checkmark.circle")
                                .font(.body)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top) // let the photos go all the way to the top of the screen
            // A11Y FIX: Dark Interface – system colors that turn dark in Dark Mode
            .foregroundStyle(Color.primary)
            .background(Color(.systemBackground))
            .navigationTitle(destination.name)
            .navigationBarTitleDisplayMode(.inline)

        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {

                    // MARK: Photos – swipe left and right; they also move by themselves every 3 seconds

                    TabView(selection: $currentPhoto) {
                        ForEach(0..<destination.photos.count, id: \.self) { index in
                            Color.gray.opacity(0.2)
                                .overlay {
                                    AsyncImage(url: destination.photos[index].url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .clipped()
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page) // swipeable pages with dots at the bottom
                    .indexViewStyle(.page(backgroundDisplayMode: .always)) // a dark pill behind the dots
                    .frame(height: 320)
                    .onReceive(timer) { _ in
                        // Bug: the photos always slide by themselves, even with Reduce Motion on.
                        withAnimation {
                            currentPhoto = (currentPhoto + 1) % destination.photos.count
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {

                        // MARK: Name and heart button

                        HStack(alignment: .top) {
                            Text(destination.name)
                                // Bug: fixed 30 pt, and not a heading
                                .font(.system(size: 30, weight: .bold))

                            Spacer()

                            // Bug: a button with no name. VoiceOver only says "Button", Voice Control shows nothing.
                            Button {
                                favorites.toggle(destination)
                            } label: {
                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                    // Bug: fixed 22 pt icon that never grows
                                    .font(.system(size: 22))
                                    .foregroundStyle(isSaved ? Color.pink : Color.primary)
                                    .padding(10)
                                    .background(Color(.secondarySystemBackground), in: .circle)
                            }
                            .buttonStyle(.plain)
                        }

                        // MARK: Region, tagline and budget

                        // Bug: region and budget squeezed onto 1 line, cut off with "…" when there's no room
                        HStack(spacing: 12) {
                            Label(destination.region, systemImage: "mappin.and.ellipse")
                                // Bug: fixed 13 pt, in light grey #AAAAAA that is too faint to read
                                .font(.system(size: 13))
                                .foregroundStyle(Color(white: 0.67))
                            BudgetView(level: destination.budget)
                        }
                        .lineLimit(1)

                        Text(destination.tagline)
                            // Bug: fixed 13 pt, in light grey #AAAAAA that is too faint to read
                            .font(.system(size: 13))
                            .foregroundStyle(Color(white: 0.67))

                        Divider()

                        // MARK: About

                        Label("About this place", systemImage: "book")
                            // Bug: fixed 16 pt, and not a heading
                            .font(.system(size: 16, weight: .bold))
                            .padding(.top, 8)
                        Text(destination.about)
                            // Bug: fixed 15 pt that never grows
                            .font(.system(size: 15))

                        // MARK: Best time to visit – one small bar per month

                        Label("Best time to visit", systemImage: "calendar")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.top, 8)

                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 4), count: 12), spacing: 10) {
                            ForEach(1...12, id: \.self) { month in
                                let isGood = destination.goodMonths.contains(month)
                                VStack(spacing: 4) {
                                    // Bug: green vs red only. This green and red are picked to be equally bright,
                                    // so with deuteranopia (red-green color blindness) or in grayscale,
                                    // every month looks the same.
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(isGood ? Color(red: 30/255, green: 175/255, blue: 0) : Color(red: 240/255, green: 75/255, blue: 45/255))
                                        .frame(height: 14)
                                    // Bug: tiny fixed 9 pt letters in light grey #AAAAAA. VoiceOver reads "J", "F", "M"…
                                    Text(monthLetters[month - 1])
                                        .font(.system(size: 9))
                                        .foregroundStyle(Color(white: 0.67))
                                }
                            }
                        }

                        // MARK: Getting there

                        Label("Getting there", systemImage: "airplane")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.top, 8)
                        Text(destination.gettingThere)
                            .font(.system(size: 15))

                        // MARK: What to prepare

                        Label("What to prepare", systemImage: "checklist")
                            .font(.system(size: 16, weight: .bold))
                            .padding(.top, 8)
                        ForEach(destination.prepare, id: \.self) { item in
                            Label(item, systemImage: "checkmark.circle")
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .ignoresSafeArea(edges: .top) // let the photos go all the way to the top of the screen
            // Bug: always black on white, even in Dark Mode
            .foregroundStyle(Color.black)
            .background(Color.white)
            .navigationTitle(destination.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    /// "📍 Central Java" in grey, for the fix version.
    private var regionLabel: some View {
        Label(destination.region, systemImage: "mappin.and.ellipse")
            // A11Y FIX: Larger Text – a text style that grows
            .font(.subheadline)
            // A11Y FIX: Sufficient Contrast – a dark enough grey
            .foregroundStyle(Color.secondary)
    }
}

#Preview("Fix off") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, false)
}

#Preview("Fix on") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, true)
}

#Preview("Fix off – Dark") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, false).preferredColorScheme(.dark)
}

#Preview("Fix on – Dark") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, true).preferredColorScheme(.dark)
}

#Preview("Fix off – Large text") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, false).dynamicTypeSize(.accessibility3)
}

#Preview("Fix on – Large text") {
    NavigationStack { DetailView(destination: .featured) }.environment(\.a11yFix, true).dynamicTypeSize(.accessibility3)
}
