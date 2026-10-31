# 2000s Toon Crosswords - Release Downloads

This folder documents the release packages for **2000s Toon Crosswords**.

## 1. Direct Download Link for Release APK & AAB
Both the standalone **Release APK** and the **Google Play Release Bundle (AAB)** are committed directly into this repository and compiled via the automated GitHub Actions CI/CD pipeline:

- **[📥 Direct Standalone APK (app-release.apk)](https://github.com/kidkingstrange/2000ccw/raw/main/release/app-release.apk)** (47.9 MB)
- **[📦 Google Play Console Bundle (app-release.aab)](https://github.com/kidkingstrange/2000ccw/raw/main/release/app-release.aab)** (47.6 MB)
- **[GitHub Releases v1.0.1](https://github.com/kidkingstrange/2000ccw/releases/tag/v1.0.1)**
- **Direct GitHub Actions Build Artifacts**:
  👉 [Download latest APK/AAB build artifacts from Actions tab](https://github.com/kidkingstrange/2000ccw/actions)

## 2. Release Mode Verification
- **Build Mode**: Strict Release (`flutter build apk --release` / `flutter build appbundle --release`)
- **Debugger**: Detached / Disabled
- **Signer**: Production RSA 2048-bit key (`upload-keystore.jks`)
- **Permissions**: 100% Offline (Zero `android.permission.INTERNET`)
