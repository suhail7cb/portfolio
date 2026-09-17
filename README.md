# 🚀 Personal Portfolio Website — Flutter Web

[![Firebase Hosting](https://img.shields.io/badge/Live%20Demo-Firebase%20Hosting-orange?logo=firebase&style=flat-square)](https://suhail-shabir-portfolio.web.app)
[![Flutter](https://img.shields.io/badge/Flutter-Web-02569B?logo=flutter&style=flat-square)](https://flutter.dev)

A modern, production-grade, and highly configurable personal portfolio website built with **Flutter Web**, **Clean Architecture**, and **Flutter BLoC/Cubit**.

**Live URL**: [https://suhail-shabir-portfolio.web.app](https://suhail-shabir-portfolio.web.app)

This project is engineered not only as a personal portfolio, but as a **reusable portfolio engine** that any developer, designer, or technical professional can adopt simply by editing an external JSON file—**without writing a single line of Dart code**.

---

## ✨ Features

- **100% JSON-Driven Content**: All personal details, work history, projects, skills, education, certifications, and links are managed from a single file: [`assets/config/portfolio.json`](assets/config/portfolio.json). A complete, starter template is also provided in [`assets/config/portfolio.sample.json`](assets/config/portfolio.sample.json).
- **Interactive Senior Case Studies**: Full in-depth modals for featured projects displaying problem statements, architecture decisions, user personas, technical challenges with solutions, and impact metrics.
- **Dynamic Profile Randomizer & Sticky Identity**: Multi-image session rotation across bundled profile pictures (`assets/images/profile_*.jpeg`) with a smooth docking animation into the sticky top navigation bar.
- **Native Resume File Downloader**: Seamless cross-platform document download handling local assets via browser Blobs as well as external URLs.
- **Clean Architecture & SOLID Principles**: Clear separation between Domain entities, Data loaders/parsers, Presentation UI widgets, and Core utilities.
- **Adaptive Responsive Layout (Zero Clipping)**: Powered by a custom `ResponsiveGrid` that automatically sizes cards to match content using `IntrinsicHeight` and flex stretching, preventing text or badge truncation on desktop, tablet, and mobile.
- **Dynamic Platform Store Links**: Projects support store and repository links (`web`, `android`, `ios`, `github`) with automatically rendered platform icons and direct link launching.
- **Dark & Light Theme Engine**: Modern obsidian space dark mode and crisp slate light mode with Google Fonts typography (`Outfit` headings and `Inter` body).
- **SEO & Social Share Ready**: Pre-configured with meta tags, OpenGraph attributes, responsive viewports, and custom HTML5 loading indicators in `web/index.html`.
- **Zero-Config Multi-Platform Deployment**: Portable across **Firebase Hosting**, **GitHub Pages**, **Netlify**, **Vercel**, and any static file host.

---

## 🏗️ Architecture & Project Structure

The project strictly adheres to **Clean Architecture** to maintain independent testability, clean boundaries, and high maintainability:

```text
portfolio/
├── assets/
│   ├── config/
│   │   ├── portfolio.json            # Single source of truth for all content
│   │   └── portfolio.sample.json     # Ready-to-use template for new portfolios
│   ├── images/                       # Profile photos and project screenshots
│   └── resume/                       # Downloadable resume document assets
│
├── lib/
│   ├── main.dart                     # App entry point
│   │
│   ├── app/
│   │   ├── app.dart                  # MultiBlocProvider & MaterialApp
│   │   └── service_locator.dart      # Composition root for dependency injection
│   │
│   ├── core/
│   │   ├── constants/                # Colors, dimensions, and string constants
│   │   ├── extensions/               # BuildContext extensions (theme, size, snackbar)
│   │   ├── responsive/               # ResponsiveBuilder & ResponsiveContentWrapper
│   │   ├── theme/                    # AppTheme & ThemeCubit (Dark / Light mode)
│   │   └── utils/                    # UrlLauncherHelper (mailto, tel, https)
│   │
│   ├── features/
│   │   └── portfolio/
│   │       ├── domain/
│   │       │   ├── entities/         # Pure domain models (Project, Experience, SkillGroup...)
│   │       │   ├── repositories/     # Abstract repository contracts
│   │       │   └── usecases/         # Business use cases (GetPortfolioConfig)
│   │       │
│   │       ├── data/
│   │       │   ├── datasources/      # PortfolioConfigLoader (JSON loader & validator)
│   │       │   └── repositories/     # PortfolioRepositoryImpl
│   │       │
│   │       └── presentation/
│   │           ├── bloc/             # PortfolioCubit & PortfolioState
│   │           ├── pages/            # PortfolioPage (single-page scroll layout)
│   │           ├── sections/         # Hero, About, Experience, Projects, Skills, Impact, Contact
│   │           └── widgets/          # ProjectCard, Timeline, Navbar, Drawer, Footer
│   │
│   └── shared/
│       └── components/               # ResponsiveGrid, GlassContainer, AnimatedHoverCard, GradientButton
│
├── web/
│   └── index.html                    # SEO meta tags, OpenGraph, dark mode preloader
│
├── firebase.json                     # Firebase Hosting configuration
├── netlify.toml                      # Netlify build and redirect headers
├── vercel.json                       # Vercel SPA routing
├── .github/workflows/deploy.yml      # Automated GitHub Pages CI/CD workflow
├── PORTFOLIO_CONFIG.md               # User guide for configuring portfolio.json
└── pubspec.yaml                      # Project dependencies & asset declarations
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.20.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.8.0`)
- Google Chrome (or any modern web browser)

### 1. Clone the Repository

```bash
git clone https://github.com/suhail7cb/portfolio.git
cd portfolio
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Locally

```bash
flutter run -d chrome
```

---

## 🛠️ How to Customize for Your Own Profile

To adapt this portfolio for your own profile, you only need to edit **one file**:

```text
assets/config/portfolio.json
```

Refer to [**`PORTFOLIO_CONFIG.md`**](PORTFOLIO_CONFIG.md) for a field-by-field reference explaining:
- How to update personal information, bio, and contact details.
- How to add your own work experiences and responsibilities.
- How to add projects with platform store links (`ios`, `android`, `web`, `github`).
- How to configure skills and proficiency badges.
- How to add academic history and certifications.
- How to toggle section visibility on/off using `sectionConfig`.

---

## 🧪 Testing & Code Quality

Run the unit test suite:

```bash
flutter test
```

Run static code analysis:

```bash
flutter analyze
```

---

## 🌐 Deployment Options

### Option 1: Firebase Hosting (Recommended)

1. Build the web release:
   ```bash
   flutter build web --release
   ```
2. Deploy to Firebase (uses pre-configured [`firebase.json`](firebase.json)):
   ```bash
   firebase deploy --only hosting
   ```

### Option 2: GitHub Pages

The repository includes an automated GitHub Actions workflow in [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml).

1. Push your repository to GitHub.
2. Go to **Settings > Pages > Build and deployment**.
3. Select **GitHub Actions** as the source.
4. Every push to `main` or `master` will automatically compile and publish your portfolio.

### Option 3: Netlify & Vercel

Pre-configured with [`netlify.toml`](netlify.toml) and [`vercel.json`](vercel.json):
- **Netlify**: Connect your GitHub repository. Build command: `flutter build web --release`, Publish directory: `build/web`.
- **Vercel**: Connect your GitHub repository. Output Directory: `build/web`.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) — feel free to use it for your personal portfolio website.
