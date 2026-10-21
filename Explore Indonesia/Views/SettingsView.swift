//
//  SettingsView.swift
//  Explore Indonesia
//
//  The Accessibility Fix switch.
//
//  This screen has NO bugs on purpose: it works the same in both versions,
//  so anyone can always find the switch and turn the fix back on.
//

import SwiftUI

struct SettingsView: View {
    /// Saved on the device. Changing it updates every screen right away.
    @AppStorage("accessibilityFixEnabled") private var fix = true

    var body: some View {
        Form {
            Section {
                Toggle("Accessibility Fix", isOn: $fix)
                if fix {
                    Text("On – you are using the accessible version of the app.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Off – you are seeing the app before the accessibility fixes.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Accessibility demo")
            } footer: {
                Text("Turn it off to experience the app the way many people with disabilities still experience apps today.")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
