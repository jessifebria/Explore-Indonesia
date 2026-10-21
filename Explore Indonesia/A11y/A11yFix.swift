//
//  A11yFix.swift
//  Explore Indonesia
//
//  HOW THE DEMO WORKS
//
//  The app has one switch in Settings: "Accessibility Fix".
//  Every screen reads it as a true/false value called `fix`:
//
//      fix == true   → the accessible version of the app
//      fix == false  → the same app with accessibility bugs planted on purpose
//
//  Each place where the two versions differ is marked with a comment:
//
//      // A11Y FIX: <Nutrition Label> – what the fix does
//
//  To list them all, run:  grep -rn "A11Y FIX" "Explore Indonesia"
//

import SwiftUI

extension EnvironmentValues {
    /// The switch value, shared with every screen. `true` = accessible version.
    @Entry var a11yFix: Bool = false
}
