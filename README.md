# 🚀 Mostafa Mohamed Elsayed — Flutter Developer Portfolio

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Vercel](https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://vercel.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A responsive, high-performance web portfolio built with **Flutter Web**. Designed specifically around the Flutter & Dart brand aesthetics with a dark-mode palette (`#0D1117`), featuring serverless contact form integration via **EmailJS**, interactive technology chips with dynamic skill-bar highlighting, and mobile/desktop cross-platform responsiveness.

---

## 🌟 Live Demo & Preview

> 🔗 **Live Website**: Deployable on Vercel with automated CI/CD!

---

## ✨ Key Features

### 1. 🎯 Hero Section
* **Infinite Typewriter Animation**: Cycles dynamically through professional titles with smooth typing, reading pause, and backspacing loops.
* **Canvas-Painted Particle System**: Lightweight floating particles with code symbols (`<>`, `{}`, `Dart`, `void`, `=>`), adaptively scaled down on mobile for 60fps performance.
* **Direct CV Download**: Instant access to PDF resume with external application launch.

### 2. 👨‍💻 About Me & Interactive Skills Matrix
* **Interactive Tech Chips**: Tap any chip (e.g. `Flutter`, `BLE`, `Wi-Fi Direct`, `TCP Sockets`, `Firebase`, `Provider`, `TinyML`) to immediately highlight the matching skill bar with glowing ambient color shadows and active indicators.
* **Real Project-Backed Skill Percentages**: Derived from real open-source architectures on GitHub.
* **Profile Photo**: Circular glowing border with blue ambient illumination and fallback handling.

### 3. 💼 Featured Projects
* **[Weave](https://github.com/MostafaMo426/Weave)** — Off-Grid Decentralized P2P Chat using Flutter, Google Nearby Connections, BLE discovery, and Wi-Fi Direct (SoftAP) with serverless cluster topology.
* **Lanco** — IoT & Smart Hardware integration via TCP/Raw Sockets, embedded communication, and mobile-to-hardware data pipelines.
* **EdgeVoice** — On-device TinyML / Audio processing, DSP, and BLE peripheral communication.
* **"View All Projects on GitHub"**: Integrated action button linking to [@MostafaMo426](https://github.com/MostafaMo426).

### 4. 🌐 Connect & Socials
* Direct cards for **GitHub** (with GitHub brand orange gradient), **LinkedIn**, and **WhatsApp** (`wa.me`) using `LaunchMode.externalApplication`.

### 5. 📬 Serverless EmailJS Contact Form
* **EmailJS Integration**: Direct email dispatch without requiring a backend server.
* **Comprehensive Validation**: Name, Email (Regex), Subject, and Message (min 10 characters) with inline error text.
* **Interactive States**: Default, Loading (`CircularProgressIndicator`), Success (`Message Sent! 🎉` with auto-reset timer), and Error handling.

### 6. 📱 Responsive & Cross-Platform
* Breakpoints: **Mobile (0–600px)**, **Tablet (601–1024px)**, and **Desktop (1025px+)**.
* Responsive hamburger navigation drawer with frosted glass styling and touch-friendly targets (≥48px).

---

## 🛠️ Tech Stack

* **Framework**: Flutter Web (Stable Channel)
* **Language**: Dart
* **Styling & Theme**: Custom AppTheme with Flutter Blue (`#54C5F8` / `#0175C2`), Dart Teal (`#00B4AB`), and Deep Background (`#0D1117`)
* **Animations**: `flutter_animate`
* **Typography**: Google Fonts (Inter)
* **Email Service**: EmailJS Browser SDK with Dart JS interop
* **Deployment Platform**: Vercel

---

## 📂 Project Structure

```text
my_portfolio/
├── assets/
│   └── Me.jpeg                  # Profile photo asset
├── lib/
│   ├── main.dart                # Application entry point & main single-page scroll
│   ├── sections/
│   │   ├── hero_section.dart    # Hero header & infinite typewriter
│   │   ├── about_section.dart   # Bio, interactive chips & animated skill bars
│   │   ├── projects_section.dart# Responsive project cards grid
│   │   ├── connect_section.dart # Social media & contact links
│   │   ├── contact_section.dart # EmailJS form with state handling
│   │   └── footer_section.dart  # Footer credits
│   ├── theme/
│   │   └── app_theme.dart       # Design system, color tokens & gradients
│   └── widgets/
│       ├── nav_bar.dart         # Sticky header with responsive mobile menu
│       ├── particle_background.dart # Canvas code particles
│       ├── scroll_aware_widget.dart # Scroll visibility observer
│       └── section_wrapper.dart # Responsive layout container
├── web/
│   ├── index.html               # Web bootstrap, SEO meta tags & EmailJS SDK
│   └── manifest.json            # PWA configuration
├── build.sh                     # Automated Linux build script for Vercel CI/CD
├── vercel.json                  # Vercel deployment configuration & SPA routing
├── package.json                 # Vercel auto-detection build command
└── pubspec.yaml                 # Flutter dependencies & assets declaration
```

---

## 🚀 Deploying on Vercel

This repository is pre-configured with `vercel.json`, `build.sh`, and `package.json` for automatic zero-configuration Vercel deployment.

### Method 1 — Deploy via Vercel Dashboard (Recommended)

1. Push this repository to your **GitHub** account (`https://github.com/MostafaMo426/my_portfolio`).
2. Go to **[vercel.com](https://vercel.com)** and sign in with GitHub.
3. Click **"Add New..."** ➔ **"Project"** and select `my_portfolio`.
4. Vercel will automatically detect the settings:
   * **Framework Preset**: `Other`
   * **Build Command**: `bash build.sh` (or `npm run build`)
   * **Output Directory**: `build/web`
5. Click **"Deploy"**. Vercel will clone Flutter, compile the release bundle, and deploy your site to a global CDN with free SSL!

---

### Method 2 — Deploy via Vercel CLI

If you have Node.js installed on your machine:

1. Install the Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Build the Flutter Web release bundle locally:
   ```bash
   flutter build web --release
   ```

3. Deploy to production:
   ```bash
   vercel --prod
   ```

---

## 💻 Local Development

### Prerequisites
* Flutter SDK (3.22+ or 3.27+)
* Google Chrome, Brave, or Edge

### Running the App
1. Clone the repository:
   ```bash
   git clone https://github.com/MostafaMo426/my_portfolio.git
   cd my_portfolio
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run locally:
   ```bash
   flutter run -d chrome --web-port 8080
   ```
   *Or for Brave Browser:*
   ```bash
   flutter run -d web-server --web-port 8080
   ```

### Terminal Commands during execution:
* Press **`r`** for **Hot Reload**.
* Press **`R`** (Shift + R) for **Hot Restart**.
* Press **`q`** to quit.

---

## 📬 Contact & Connect

* **Email**: [safymo81@gmail.com](mailto:safymo81@gmail.com)
* **LinkedIn**: [mostafa-mohamed-00435b332](https://www.linkedin.com/in/mostafa-mohamed-00435b332/)
* **WhatsApp**: [+20 120 485 2902](https://wa.me/201204852902)
* **GitHub**: [@MostafaMo426](https://github.com/MostafaMo426)

---

Developed with 💙 by **Mostafa Mohamed Elsayed**
