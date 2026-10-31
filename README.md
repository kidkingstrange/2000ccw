# 📺 2000s Toon Crosswords

> **If you are a child of the 2000s, this is the game you were born to play!**

Step back into the golden age of Saturday morning cartoons, overflowing cereal bowls, and unstoppable after-school cable marathons. **2000s Toon Crosswords** is a premium, paid, 100% offline word puzzle game celebrating the greatest era in animation history (2000–2010s).

---

## 🕹️ Highlights & Features

- **If You Grew Up in the 2000s, You'll Love This**: Over 157 verified animated series and movies covering Cartoon Network, Nickelodeon, Disney Channel & Jetix, Kids' WB & 4Kids, KidsCo, JimJam, and Teletoon.
- **Dual Game Modes (400 Launch Levels)**:
  - **Classic Crosswords (200 Levels)**: Connected alphanumeric grids (Easy 8x8 to Expert 12x12) with word-locking feedback, mint-green animations, and haptic chimes.
  - **Emoji Title Rebus (200 Levels)**: Visual emoji riddle sequences with **dedicated word rows** that prevent awkward mid-word line breaks and adapt dynamically to your screen width.
- **2,612 Double-Source Verified Trivia Clues**: Strictly verified against TMDb, Wikipedia, and official Emmy/Annie historical records.
- **Gamified Economy & 3-Tier Hint Shop**:
  - Earn coins on every solved word (+50), rebus (+100), and level completion (+200).
  - 3-tier progressive hint shop: Reveal First Letter (50), Reveal Random Letter (100), Reveal Entire Word (250).
- **Trophy Hall / Dex**: Every cleared level permanently unlocks a verified behind-the-scenes trivia card explaining pilot origins, voice actor secrets, and animation trivia.
- **100% Offline & Zero-Permission**: No `android.permission.INTERNET`, zero ads, zero trackers, zero subscriptions, zero in-app purchases.

---

## 📺 Channel Packs Included
* **Cartoon Network**: *Ben 10, Teen Titans, Samurai Jack, Foster's Home, Codename: Kids Next Door, Billy & Mandy, Chowder, Flapjack, Ed Edd n Eddy, Courage the Cowardly Dog, Regular Show, Adventure Time...*
* **Nickelodeon**: *Avatar: The Last Airbender, SpongeBob SquarePants, The Fairly OddParents, Danny Phantom, Invader Zim, Jimmy Neutron, My Life as a Teenage Robot, ChalkZone, All Grown Up...*
* **Disney Channel & Jetix**: *Kim Possible, Phineas and Ferb, The Proud Family, Lilo & Stitch, American Dragon, SRMTHG, Yin Yang Yo!, Pucca, W.I.T.C.H....*
* **Kids' WB & 4Kids**: *Jackie Chan Adventures, Static Shock, X-Men: Evolution, The Batman, Spectacular Spider-Man, Transformers: Animated, Yu-Gi-Oh! GX, TMNT 2003...*
* **KidsCo Classics**: *Rescue Heroes, Dino Squad, The New Adventures of Madeline, Archie's Weird Mysteries, Sabrina: The Animated Series, Corduroy, Ned's Newt...*
* **JimJam Favorites**: *Bob the Builder, Thomas & Friends, Fireman Sam, Pingu, Barney & Friends, Postman Pat, Kipper, Angelina Ballerina, Roary...*
* **Teletoon & International**: *Total Drama Island, 6teen, Code Lyoko, Winx Club, Martin Mystery, Atomic Betty, Grossology...*

---

## 🛠️ Tech Stack & Architecture
- **Framework**: Flutter 3.47+ (Dart 3.13+)
- **Architecture**: Pure-Dart decoupled engines (`CrosswordEngine`, `RebusEngine`) with 100% unit test coverage.
- **Build-Time Generation**: Python compilers in `tools/` pre-generate all static JSON puzzles in `assets/puzzles/` for instant 60 FPS performance on all mobile devices.
- **Keyboard System**: Native device IME integration with `WidgetsBindingObserver` for resilient soft keyboard focus recovery.

---

## 🚀 Instant Downloads & Releases

### 📱 [📥 Download Android APK (Direct Sideload)](https://github.com/kidkingstrange/2000ccw/raw/main/release/app-release.apk)
*Tap to download the standalone, signed production `.apk` directly to your phone. 100% offline, zero ads!*

* **Direct Repository Links**:
  - **Standalone Android APK**: [`release/app-release.apk`](https://github.com/kidkingstrange/2000ccw/raw/main/release/app-release.apk)
  - **Google Play App Bundle**: [`release/app-release.aab`](https://github.com/kidkingstrange/2000ccw/raw/main/release/app-release.aab)
- **GitHub Releases Page**:
  👉 [GitHub Releases v1.0.1 (Production Release)](https://github.com/kidkingstrange/2000ccw/releases)
- **Google Play Testing Track**:
  👉 [Join the Official Google Play Test](https://play.google.com/apps/testing/com.retrogames.tooncrosswords.toon_crosswords)

---

## 🛠️ 100% Flutter & Pure-Dart Architecture
- **Framework**: 100% Flutter Framework & Pure Dart 3 (Zero Python runtime code).
- **Native Keyboard**: Fully utilizes the phone's native soft keyboard (Gboard, Samsung Keyboard, iOS) without any clunky virtual on-screen extra keyboards.
- **Responsive Design**: Automatically scales crossword grids and rebus rows to any screen aspect ratio.
- **Strict Anti-Leak Protection**: 100% of clues and rebus hints are verified with zero spoilers/leaks. Answers are never displayed in questions or clues.
