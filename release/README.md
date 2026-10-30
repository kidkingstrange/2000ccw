# 2000s Toon Crosswords - Release Downloads

This folder documents the release packages for **2000s Toon Crosswords**.

## 1. Direct Download Link for Release APK & AAB
Both the standalone **Release APK** and the **Google Play Release Bundle (AAB)** are compiled via the automated GitHub Actions CI/CD pipeline on every commit/tag to `main`.

- **Latest Production Release (APK & AAB)**:
  👉 [Download from GitHub Releases (v1.0.0)](https://github.com/kidkingstrange/2000ccw/releases)
- **Direct GitHub Actions Build Artifacts**:
  👉 [Download latest APK/AAB build artifacts from Actions tab](https://github.com/kidkingstrange/2000ccw/actions)

## 2. Release Mode Verification
- **Build Mode**: Strict Release (`flutter build apk --release` / `flutter build appbundle --release`)
- **Debugger**: Detached / Disabled
- **Signer**: Production RSA 2048-bit key (`upload-keystore.jks`)
- **Permissions**: 100% Offline (Zero `android.permission.INTERNET`)
