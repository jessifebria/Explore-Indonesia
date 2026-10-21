# Explore Indonesia 🇮🇩

**Wisata Nusantara** is a small Indonesian travel guide for iPhone, built to show what accessible apps look like and what inaccessible ones feel like.

This project was created for the **[Singapore Inclusive Design Week 2026](https://una.tech.gov.sg/articles/inclusive-design-week-2026/)** workshop. It's a live demo app: one switch turns the whole app from an accessible version into one that has the bugs many apps still ship with, so you can try each bug yourself and then see the fix.

---

## ✨ The idea: one switch, two apps

Open **Settings** and flip **Accessibility Fix**

The change takes effect right away. You don't need to relaunch the app.

---

## ♿ What the fix covers

Each fix maps to one of Apple's [Accessibility Nutrition Labels](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/overview-of-accessibility-nutrition-labels):

| Nutrition Label | Bug (fix off) | Fix (fix on) |
|---|---|---|
| **VoiceOver** | Cards are read as scattered fragments, photos aren't described, the heart button doesn't say if a place is saved, and section titles aren't headings. | Each card is one button, photos have alt text, the heart says "Favorite, Selected", and section titles are headings you can jump between with the rotor. |
| **Voice Control** | Icon-only tabs and buttons have no name you can say. | "Tap Favorite" works, and "Show names" shows a label on every button. |
| **Larger Text** | Fixed font sizes and a fixed 2-column grid cut text off. | Text styles that grow, wrapping text, and a 1-column grid at the largest sizes. |
| **Dark Interface** | Hard-coded white backgrounds and black text. | Semantic system colors. |
| **Differentiate Without Color** | The "best time to visit" months are green vs. red only. | Every month also shows a ✓ or ✗. |
| **Sufficient Contrast** | Light grey text on white. | Grey text with at least 4.5:1 contrast. |
| **Reduced Motion** | The photo carousel always slides on its own. | The carousel stays still when Reduce Motion is on. |

---

### How it works

- The switch is stored with `@AppStorage("accessibilityFixEnabled")`, and it is **on** by default.
- It's passed to every screen as an environment value, `\.a11yFix` (see [A11yFix.swift](Explore%20Indonesia/A11y/A11yFix.swift)).
- Each view reads `@Environment(\.a11yFix) var fix` and branches only where a fix applies.

---

## 📱 Screens

- **Home**: a featured destination and a grid of top recommendations, plus a "Did you know?" fact.
- **Detail**: a photo carousel, price level, the best months to visit, and how to get there.
- **Favorites**: the places you've saved with the heart button.
- **Settings**: the Accessibility Fix switch.

Destinations include Raja Ampat, Borobudur, Mount Bromo, Labuan Bajo, Danau Toba, Ubud, Tana Toraja, Lombok and more, all loaded from [destinations.json](Explore%20Indonesia/Data/destinations.json).

---

## 🧪 Try it yourself

Turn **Accessibility Fix** off, then try these settings on your iPhone or in the Simulator:

| Try this | Where to find it |
|---|---|
| VoiceOver | Settings › Accessibility › VoiceOver |
| Voice Control, then say "Show names" | Settings › Accessibility › Voice Control |
| Larger Text | Settings › Accessibility › Display & Text Size › Larger Text |
| Dark Mode | Settings › Display & Brightness |
| Grayscale | Settings › Accessibility › Display & Text Size › Color Filters |
| Reduce Motion | Settings › Accessibility › Motion |
| Sufficient Contrast | Settings › Accessibility › Display & Text Size > Bold Text, Increase Contrast, and Reduce Transparency |

Then turn the fix back on and compare. In Xcode you can also use **Accessibility Inspector › Audit** to check each screen.

---

## 📂 Project structure

```
Explore Indonesia/
├── A11y/        The Accessibility Fix environment value
├── Data/        destinations.json
├── Model/       Destination, Favorites, navigation
└── Views/       Home, Detail, Favorites, Settings and shared cards
```

---

## 💙 About

Made by **Jessi Febria** for the **[Singapore Inclusive Design 2026](https://una.tech.gov.sg/articles/inclusive-design-week-2026/)** workshop, to help designers and developers *feel* the difference accessibility makes. This project was made together with AI & the skills from this [open-source repo](https://github.com/twostraws/Swift-Agent-Skills#accessibility-skills)
