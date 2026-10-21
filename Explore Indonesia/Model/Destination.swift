//
//  Destination.swift
//  Explore Indonesia
//
//  One tourist destination. All destinations are read from Data/destinations.json.
//
// TODO: content review – the texts in destinations.json.
//

import Foundation

struct Destination: Identifiable, Hashable, Decodable {
    let id: String
    let name: String
    let region: String
    /// Price level from 1 to 3.
    let budget: Int
    let tagline: String
    let about: String
    let gettingThere: String
    /// The "What to prepare" checklist.
    let prepare: [String]
    /// Months that are a good time to visit, as numbers: 1 = January … 12 = December.
    let goodMonths: [Int]
    let photos: [Photo]
}

struct Photo: Hashable, Decodable {
    /// Where the photo is downloaded from.
    let url: URL
    /// A short description of the photo, read aloud by VoiceOver.
    let altText: String
}

/// The shape of destinations.json: which place is featured, and the list of all places.
struct DestinationsFile: Decodable {
    let featuredId: String
    let destinations: [Destination]
}

extension Destination {
    /// Everything in destinations.json, read once when the app starts.
    static let file: DestinationsFile = {
        let url = Bundle.main.url(forResource: "destinations", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(DestinationsFile.self, from: data)
    }()

    static var all: [Destination] { file.destinations }

    /// The highlighted place, used by the previews.
    static var featured: Destination { all.first { $0.id == file.featuredId }! }

    /// The grid on Home: every place, in the order of destinations.json.
    static var recommendations: [Destination] { all }
}
