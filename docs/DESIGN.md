# Design System & Wireframes: 2000s Toon Crosswords

## 1. Brand Identity & Motif
* **App Title**: 2000s Toon Crosswords
* **Tagline**: The Ultimate Saturday Morning & Cable Cartoon Brain Buster
* **Brand Icon Motif**:
  A retro convex bubble CRT television set with dual crooked antenna ears (rabbit ears with foil balls), encased in vibrant cheerful orange framing. The cathode ray screen glows electric cyan, broadcasting vivid lime-green slime splatters across a geometric 3x3 crossword grid. The motif embodies early-2000s nostalgia, Saturday morning cereal broadcasts, and cable network irreverence.
* **Aesthetic Direction**:
  "Neo-Retro Saturday Morning": Chunky tactile buttons, high-contrast borders (2.5dp solid ink navy/black), soft drop shadows (`#000000` with 0 opacity blur and 3dp Y offset), playful geometric badges, and neon accents against deep space canvas backgrounds.

---

## 2. Color Palette & Design Tokens

### Primary Theme Tokens
| Token Name | Hex Code | Semantic Role |
| :--- | :--- | :--- |
| **Slime Green** | `#39FF14` | Primary brand accent, word-solve lock state, positive affirmations, level complete highlights |
| **Electric Cyan** | `#00F0FF` | Secondary accent, active cell selection, Rebus hint tags, special badges |
| **Cheerful Orange**| `#FF6B35` | Action buttons, coin currency indicators, streak flame counter, playful warning alerts |
| **Deep Space Black** | `#12121E` | Primary dark surface / app background, high contrast framing |
| **Surface Dark Card** | `#1E1E30` | Card elevation surfaces, grid cell backgrounds (unselected), container boxes |
| **Parchment Milk** | `#FFFDF7` | Primary text on dark surfaces, light mode cell surfaces, pure readability |
| **Mint Solved** | `#2EC4B6` | Locked solved word cell background |
| **Locked Tile Grey**| `#2A2A3D` | Inactive / locked grid cell filler |
| **Error Coral** | `#FF4757` | Invalid letter check, error shake feedback |

### Channel Category Accents
* **Cartoon Network**: `#00F0FF` (Electric Cyan) & `#FFFFFF` (Checkerboard Monochrome)
* **Nickelodeon**: `#FF6B35` (Splatter Orange)
* **Disney Channel & Jetix**: `#FF2A6D` (Neon Magenta) & `#05D9E8` (Cyber Blue)
* **Kids' WB & 4Kids**: `#FFCC00` (Electric Yellow) & `#333399` (Deep Blue)
* **KidsCo**: `#4D96FF` (Sky Blue) & `#6BCB77` (Pastel Green)
* **JimJam**: `#FFD93D` (Sunshine Yellow) & `#FF6B6B` (Friendly Coral)
* **Teletoon & International**: `#9D4EDD` (Arcade Purple)

---

## 3. Typography & Font Hierarchy
* **Headings & Display**: `Fredoka` (SemiBold / Bold) — rounded, friendly, high-energy retro cartoon feel.
* **Body, Clues & Labels**: `Nunito` (Regular / SemiBold / Bold) — high legibility on compact mobile displays, wide aperture letters.
* **Emoji Riddles (Rebus)**: `Noto Color Emoji` — bundled locally in `assets/fonts/` to ensure 100% deterministic emoji display without OS fragmentation or missing character boxes.

### Type Scale
* **Display 1 (Game Title / Banner)**: 32sp, Bold, Fredoka
* **Heading 1 (Screen Title / Level Num)**: 24sp, SemiBold, Fredoka
* **Heading 2 (Word Clue / Rebus Row)**: 18sp, Bold, Nunito
* **Grid Cell Letter**: 20sp, Bold, Fredoka (dynamically scaled via `FittedBox`)
* **Body Regular (Trivia Fact)**: 15sp, Regular, Nunito
* **Caption / Tags**: 12sp, Bold, Nunito

---

## 4. UI Architecture & Screen Wireframes

### Screen 1: Home Dashboard
```
+-----------------------------------------------------------+
| [=] Settings                    (🔥 7)   (🪙 450 Coins)   |
|                                                           |
|             📺 2000s TOON CROSSWORDS                      |
|                                                           |
| +-------------------------------------------------------+ |
| | OVERALL COMPLETION                            64%     | |
| | [===========================>               ]         | |
| | 128/200 Cleared   •   342 ⭐ Stars   •   94 Trophies   | |
| +-------------------------------------------------------+ |
|                                                           |
| [ ▶ QUICK PLAY (Next Unsolved Level) ]                     |
|                                                           |
| [ 🕹️ SELECT CHANNEL PACK ]    [ 🧩 DAILY CHALLENGE ]      |
|                                                           |
| [ 🏆 TROPHY DEX & LORE ]       [ 💡 HINT SHOP ]            |
+-----------------------------------------------------------+
```

### Screen 2: Channel Pack & Level Selector
* Tab bar filtering across channels:
  `[ All | Cartoon Network | Nickelodeon | Disney/Jetix | Kids' WB | KidsCo | JimJam ]`
* Level grid with card indicators:
  * Locked levels: Closed padlock icon, grey surface.
  * Unlocked levels: Level number, mode badge (`[Crossword]` or `[Rebus]`), 0 to 3 earned stars.
  * Solved levels: Mint checkmark, gold stars, quick review option.

### Screen 3: Classic Crossword Game Screen
```
+-----------------------------------------------------------+
| [<] Back       Level 14 • Cartoon Network      (🪙 450)   |
|                                                           |
|       +---+---+---+---+---+---+---+                       |
|       | 1 |   | 2 |   |   |   |   |                       |
|       +---+---+---+---+---+---+---+                       |
|       |   | # |   | # |   | # |   |                       |
|       +---+---+---+---+---+---+---+                       |
|       | 3 |   |   |   |   |   |   |                       |
|       +---+---+---+---+---+---+---+                       |
|                                                           |
| +-------------------------------------------------------+ |
| | 3 ACROSS: Ben's alien-transforming wrist device (8)   | |
| | [< Prev Clue]       [Reveal 💡]          [Next Clue >]| |
| +-------------------------------------------------------+ |
|                                                           |
| [ NATIVE SOFT KEYBOARD (WidgetsBindingObserver Attached)] |
+-----------------------------------------------------------+
```
* **Interactive Grid Rules**:
  * Tap cell: Activates cell with Electric Cyan highlight.
  * Tap active cell again: Toggles direction between Across and Down.
  * Solved word: Animates mint green ripple, emits haptic tick, displays check badge, locks cells permanently.
  * Minimum touch target: 48dp x 48dp on all screen densities.

### Screen 4: Emoji & Icon Rebus Screen
```
+-----------------------------------------------------------+
| [<] Back          Level 22 • Rebus             (🪙 550)   |
|                                                           |
| +-------------------------------------------------------+ |
| |                   👦  +  ⌚  +  👽                     | |
| |             "Hero who wears the Omnitrix"             | |
| +-------------------------------------------------------+ |
|                                                           |
| Word 1:                                                   |
| +---+---+---+                                             |
| | B | E | N |                                             |
| +---+---+---+                                             |
|                                                           |
| Word 2:                                                   |
| +---+---+                                                 |
| | 1 | 0 |                                                 |
| +---+---+                                                 |
|                                                           |
| [ 💡 1st Letter (50) ]  [ 💡 Random (100) ]  [ Reveal (250) ] |
+-----------------------------------------------------------+
```
* **Dedicated Word Rows**:
  * Titles with multiple words are NEVER broken across random wraps. Each word occupies its own dedicated row.
  * Each word row uses `FittedBox` to scale smoothly to the device width.
  * Fixed punctuation (dashes, apostrophes, colons) is displayed as non-editable separators.

### Screen 5: Solved Victory Lore Card Modal
```
+-----------------------------------------------------------+
|                    🎉 PUZZLE SOLVED!                      |
|                                                           |
|                    ⭐⭐⭐ EXCELLENT!                       |
|                    +200 Coins Earned                      |
|                                                           |
| +-------------------------------------------------------+ |
| | 🏆 UNLOCKED TROPHY DEX CARD: BEN 10                   | |
| |                                                       | |
| | "The Omnitrix was originally designed to transform    | |
| | Ben into 10 different human superheroes before alien  | |
| | heroes were chosen."                                  | |
| |                                                       | |
| | Sources: Wikipedia, TMDb                              | |
| +-------------------------------------------------------+ |
|                                                           |
| [ 📜 View in Trophy Hall ]         [ ➡️ NEXT LEVEL ]      |
+-----------------------------------------------------------+
```

---

## 5. Accessibility & Tactile Feedback
* Contrast ratios strictly adhere to WCAG AAA standards (> 7:1 for text on dark/light surfaces).
* All interactive buttons, cell slots, and clue selectors have minimum 48dp target bounding boxes.
* System haptic feedback on:
  * Key tap: Light impact
  * Word solved: Medium success notification impact
  * Puzzle complete: Heavy celebratory haptic vibration
* Native keyboard soft-focus recovery:
  * Uses `WidgetsBindingObserver.didChangeAppLifecycleState` to re-request focus when returning from background, eliminating Android keyboard disconnects.
