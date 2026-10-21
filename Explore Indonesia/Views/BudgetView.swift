//
//  BudgetView.swift
//  Explore Indonesia
//
//  The budget as 3 dollar signs:
//    1 = $ green, $ $ grey
//    2 = $ $ green, $ grey
//    3 = $ $ $ green
//  Used on the Home cards and Detail.
//

import SwiftUI

struct BudgetView: View {
    /// 1, 2 or 3 – how many dollar signs are green
    let level: Int

    @Environment(\.a11yFix) private var fix

    var body: some View {
        let dollars = HStack(spacing: 1) {
            ForEach(1...3, id: \.self) { number in
                Image(systemName: "dollarsign")
                    .foregroundStyle(number > level ? Color.gray : Color.green)
            }
        }

        if fix {
            HStack(spacing: 4) {
                dollars
            }
            // A11Y FIX: Larger Text – grows with the text size, instead of a fixed 13 pt
            .font(.subheadline)
            // A11Y FIX: VoiceOver – read as one sentence, "Price level: 2 out of 3",
            // instead of "Dollar sign, Dollar sign, Dollar sign"
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Price level: \(level) out of 3")
        } else {
            HStack(spacing: 4) {
                dollars
            }
            .font(.system(size: 13))
            // Bug: VoiceOver reads each icon, "Dollar sign, Dollar sign, Dollar sign",
            // and the color (green or grey) that tells the level is never read
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(1...3, id: \.self) { level in
            BudgetView(level: level).environment(\.a11yFix, false)
        }
        ForEach(1...3, id: \.self) { level in
            BudgetView(level: level).environment(\.a11yFix, true)
        }
    }
}

