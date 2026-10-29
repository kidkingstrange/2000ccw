# Architectural & Design Decisions

## 1. Core Architecture & Philosophy
* **Decoupled Pure-Dart Game Engines**: All crossword grid parsing, crossword state management, word intersection validations, rebus evaluation, and clue tracking are isolated in `lib/engine/`. Zero Flutter/UI imports in the engine allows 90%+ pure unit test coverage with instant test executions.
* **Build-Time Generation vs Runtime Generation**: Crossword backtracking and dense grid generation are computationally non-deterministic and memory-intensive on 2GB budget Android devices. All crosswords and rebus levels are pre-compiled and validated at build time into static JSON manifests under `assets/puzzles/`. Runtime execution is strictly O(1) loading and verification.
* **Zero Network & Zero Permission Footprint**: The application does not declare `android.permission.INTERNET` in `AndroidManifest.xml`. No external network calls, no analytics trackers, no ad networks, no data collection. 100% offline, privacy-guaranteed, compliant with COPPA / GDPR / Google Play Families / Paid App policies.
* **Zero Copyright Risk**: No studio stills, logos, frames, or copyrighted character artwork. Original flat geometric illustrations, custom vector icons, open-source fonts, and strictly factual fair-use trivia with dual independent source verification.

## 2. Technical Stack Choices
* **Flutter & Dart SDK**: Flutter Stable with sound null-safety.
* **Fonts**: Bundled `NotoColorEmoji.ttf` to guarantee consistent, high-fidelity emoji riddle rendering across Android 8 through 15+ without tofu/blank square boxes. `Fredoka` for punchy retro cartoon display headings and `Nunito` for ultra-legible clue and UI typography.
* **State & Persistence**: Pure-Dart lightweight offline storage utilizing JSON-serialized key-value stores (`shared_preferences` / file-backed JSON store in application documents directory), supporting atomic disk writes and auto-save on every letter entry.
* **Input Management**: Android IME Native Keyboard integration via `WidgetsBindingObserver` to re-request soft keyboard focus on resume, resolving Android focus detachment glitches.

## 3. Brand & Theme Tokens
* **Theme Name**: 2000s Toon Crosswords
* **Niche Theme**: Saturday Morning & Cable Cartoons (Cartoon Network, Nickelodeon, Disney Channel, Kids' WB, Jetix) [2000–2010/2015]
* **Target Launch Price**: NGN 5,000 (with parity pricing for international markets: $2.99 - $3.49 USD)
* **Palette**:
  * Slime Green: `#39FF14`
  * Electric Cyan: `#00F0FF`
  * Cheerful Orange: `#FF6B35`
  * Deep Space Black: `#12121E`
  * Parchment Milk: `#FFFDF7`
