# Portfolio Configuration Guide

Welcome! This portfolio website is 100% data-driven. You can customize the entire website—including your name, biography, job history, projects, skills, education, certifications, and store links—by simply editing a single JSON file.

**No Dart or Flutter experience is required!**

---

## 📁 Configuration File Location

The configuration file is located at:

```text
assets/config/portfolio.json
```

Whenever you make changes to this file and refresh or rebuild the application, the entire portfolio automatically updates.

---

## 📋 JSON Structure Overview

The root of `portfolio.json` is a JSON object containing the following top-level keys:

```json
{
  "metaTitle": "Your Name | Professional Title",
  "metaDescription": "Short description for search engines and social shares.",
  "sectionConfig": { ... },
  "personalInfo": { ... },
  "navigationItems": [ ... ],
  "socialLinks": [ ... ],
  "experiences": [ ... ],
  "projects": [ ... ],
  "skillGroups": [ ... ],
  "achievements": [ ... ],
  "education": [ ... ],
  "certifications": [ ... ]
}
```

---

## 🛠️ Field-by-Field Reference

### 1. `metaTitle` & `metaDescription` (SEO)

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `metaTitle` | String | Optional | The browser tab title and OpenGraph title. |
| `metaDescription` | String | Optional | Brief summary for search engines and social media previews. |

**Example:**
```json
"metaTitle": "Alex Rivera | Staff Mobile Architect (iOS & Flutter)",
"metaDescription": "Portfolio of Alex Rivera, Mobile Architect with 10+ years of experience building high-scale iOS & Android applications."
```

---

### 2. `sectionConfig` (Show / Hide Sections)

Allows you to dynamically enable or disable any section of the website. If you don't have certifications or achievements yet, simply set them to `false`, and the website will automatically hide that section without leaving empty space.

| Field | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `showHero` | Boolean | `true` | Main greeting, title, and action buttons. |
| `showAbout` | Boolean | `true` | Professional summary and career narrative. |
| `showHighlights` | Boolean | `true` | "What I Bring to the Table" value cards. |
| `showExperience` | Boolean | `true` | Career trajectory timeline. |
| `showProjects` | Boolean | `true` | Filterable project showcase. |
| `showSkills` | Boolean | `true` | Categorized technical expertise matrix. |
| `showImpact` | Boolean | `true` | Key enterprise achievements and leadership impact. |
| `showEducation` | Boolean | `true` | Academic degree history. |
| `showCertifications`| Boolean | `true` | Continuous learning and certifications. |
| `showContact` | Boolean | `true` | Contact details touchpoints and message sender. |

**Example:**
```json
"sectionConfig": {
  "showHero": true,
  "showAbout": true,
  "showHighlights": true,
  "showExperience": true,
  "showProjects": true,
  "showSkills": true,
  "showImpact": false,
  "showEducation": true,
  "showCertifications": true,
  "showContact": true
}
```

---

### 3. `personalInfo` (Your Profile)

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `name` | String | **Required** | Your full name. |
| `title` | String | **Required** | Your primary job title (e.g., "Mobile Application Developer (iOS & Flutter)"). |
| `tagline` | String | Optional | Punchy one-sentence subtitle below your name. |
| `location` | String | Optional | City, Country or "Remote". |
| `email` | String | **Required** | Your primary contact email address. |
| `phone` | String | Optional | Your phone number with country code. |
| `totalExperience` | String | Optional | Summary badge (e.g., "10+ Years in Mobile Development"). |
| `professionalSummary` | String | Optional | Executive overview paragraph. |
| `highlights` | Array of Strings | Optional | 4–6 bullet items shown in the "What I Bring to the Table" grid. |
| `professionalDevelopmentSummary` | String | Optional | Narrative detailing your career journey and impact. |
| `profileImageUrl` | String or `null` | Optional | Set to `null` to randomly rotate photos from `assets/images/profile_*.jpeg` via `AppConstants.profilePic`, or specify an explicit image asset path / external HTTPS URL. |
| `resumeDownloadUrl` | String or `null` | Optional | Direct link to resume. Supports local asset paths (e.g. `"assets/resume/Suhail_Shabir.docx"`) triggering native browser download via `FileDownloader`, or external download URLs. |

**Example:**
```json
"personalInfo": {
  "name": "Jane Doe",
  "title": "Staff Mobile Engineer (iOS & Flutter)",
  "tagline": "Building scalable iOS & Flutter products with clean architecture, great UX, and real-world impact.",
  "location": "San Francisco, CA",
  "email": "jane.doe@example.com",
  "phone": "+1 (555) 019-2834",
  "totalExperience": "10+ Years in Mobile Development",
  "professionalSummary": "Accomplished mobile software engineer and technical leader with over a decade of experience engineering resilient, high-volume mobile systems...",
  "highlights": [
    "Expert-level proficiency in Swift, SwiftUI, Flutter, Dart, and Clean Architecture",
    "Strong focus on UX polish, smooth 60fps animations, and accessibility",
    "Proven technical leadership, architecture reviews, and team mentorship"
  ],
  "professionalDevelopmentSummary": "Over the past decade, my engineering journey has spanned high-growth startups and Fortune 500 enterprises...",
  "profileImageUrl": null,
  "resumeDownloadUrl": "assets/resume/Suhail_Shabir.docx"
}
```

---

### 4. `experiences` (Work History & Interactive Timeline)

An array of past roles displayed chronologically as an interactive timeline with focus cards and dual view mode (Timeline / Cards).

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `role` | String | **Required** | Job title / position name. |
| `company` | String | **Required** | Company or organization name. |
| `location` | String | Optional | Location (e.g., "San Francisco, CA", "Remote"). |
| `period` | String | **Required** | Timeframe (e.g., "2022 – Present"). |
| `durationText` | String | Optional | Badge text (e.g., "Current Role", "3 Years"). |
| `isCurrent` | Boolean | Optional | Set `true` to highlight the role as current with an active status glow. |
| `description` | String | Optional | High-level summary of responsibilities and scope. |
| `associatedProjectTitle` | String | Optional | Title of a project from `projects` linked to this role. |
| `responsibilities` | Array of Strings | Optional | Key contributions, technical milestones, and team achievements. |
| `impact` | Array of Strings | Optional | Measurable outcome badges (e.g. `["2M+ Active Users", "45% Faster Startup"]`). |
| `technologies` | Array of Strings | Optional | Tech stack tags (e.g. `["Flutter", "Swift", "Clean Architecture"]`). |

**How to add a new job experience:**
```json
{
  "role": "Staff Mobile Engineer & Technical Lead",
  "company": "Enterprise Global Technologies",
  "location": "San Francisco, CA",
  "period": "2022 – Present",
  "durationText": "Current Role",
  "isCurrent": true,
  "description": "Directing architecture and technical roadmaps for flagship mobile platforms used by 2M+ monthly active users.",
  "associatedProjectTitle": "OmniCommerce Mobile",
  "responsibilities": [
    "Architected core offline-first database synchronization and reactive state management.",
    "Reduced app launch latency by 45% and improved crash-free rate to 99.94%.",
    "Mentored a distributed team of 12 mobile developers across iOS and Android squads."
  ],
  "impact": [
    "2M+ Monthly Active Users",
    "45% Faster App Cold Start",
    "99.94% Crash-Free Sessions"
  ],
  "technologies": ["Flutter", "Dart", "Swift", "BLoC", "Clean Architecture", "CI/CD"]
}
```

---

### 5. `projects` (Portfolio Showcase & Store Links)

An array of projects displayed in the interactive filterable grid.

| Field | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `title` | String | **Required** | Project title. |
| `client` | String or `null` | Optional | Client or employer name. |
| `duration` | String or `null` | Optional | Project duration (e.g. "6 Months", "14 Months"). |
| `isFeatured` | Boolean | Optional | Set `true` to show this project when the "Featured" filter tab is selected. |
| `category` | String | Optional | Category used for filter tabs (e.g., "Enterprise", "Fintech", "Health", "Others"). |
| `overview` | String | Optional | Executive summary of the application. |
| `features` | Array of Strings | Optional | Feature highlights displayed in the Case Study dialog. |
| `userPersonas` | Array of Strings | Optional | Target audience personas (e.g. `["Store Manager", "Shopper"]`). |
| `technologies` | Array of Strings | Optional | Tech stack tags (e.g. `["Flutter", "Swift", "REST APIs"]`). |
| `platforms` | Array of Strings | Optional | Platform badges (e.g. `["iOS", "Android"]`). |
| `problem` | String | Optional | Core problem statement or business challenge addressed. |
| `solution` | String | Optional | Technical and product solution delivered. |
| `roleDescription` | String | Optional | Your role and responsibilities on the project. |
| `architectureSteps` | Array of Strings | Optional | Key architecture decisions and design patterns utilized. |
| `challenges` | Array of Objects | Optional | Challenges faced and how you overcame them (`[{"challenge": "...", "resolution": "..."}]`). |
| `impactMetrics` | Array of Objects | Optional | Highlighting quantitative metrics (`[{"metric": "1M+", "label": "Active Users"}]`). |
| `links` | Object | Optional | Store & Web links (see below). |

#### 🔗 Platform Store & Code Links (`links` object):

| Key | Supported Value | Resulting UI Icon & Action |
| :--- | :--- | :--- |
| `ios` | Apple App Store URL | Displays Apple logo; opens App Store in browser. |
| `android` | Google Play Store URL | Displays Google Play store icon; opens Play Store in browser. |
| `web` | Web Application URL | Displays Globe/Web icon; opens live web page. |
| `github` | Source Code URL | Displays Code icon; opens repository in browser. |

> **Note**: If a link is omitted or set to `null`, the icon is automatically omitted.

**How to add a new project:**
```json
{
  "title": "OmniCommerce Mobile",
  "client": "Global Retail Group",
  "duration": "14 Months",
  "category": "Enterprise",
  "isFeatured": true,
  "overview": "Flagship omnichannel retail application integrating barcode scanning and inventory sync.",
  "features": [
    "Real-time product inventory lookup and interactive in-store maps",
    "One-touch checkout with Apple Pay and Google Pay"
  ],
  "userPersonas": ["Retail Shopper", "Store Associate"],
  "technologies": ["Flutter", "Dart", "BLoC", "REST APIs", "Apple Pay"],
  "platforms": ["iOS", "Android"],
  "problem": "Legacy hybrid app suffered from slow checkout and frequent sync failures.",
  "solution": "Architected a reactive Flutter app with localized SQLite caching and optimistic UI.",
  "roleDescription": "Lead Architect overseeing mobile foundation and payment integration.",
  "architectureSteps": [
    "Clean Architecture separating Domain, Data, and Presentation layers",
    "Predictive cache pre-fetching for high-volume store categories"
  ],
  "challenges": [
    {
      "challenge": "High latency in concrete store basements.",
      "resolution": "Built an offline-first transactional sync queue."
    }
  ],
  "impactMetrics": [
    { "metric": "1M+", "label": "Active Users" },
    { "metric": "4.8★", "label": "Store Rating" }
  ],
  "links": {
    "web": "https://example.com/omnicommerce",
    "android": "https://play.google.com/store/apps/details?id=com.example.app",
    "ios": "https://apps.apple.com/app/id123456789",
    "github": null
  }
}
```

---

### 6. `skillGroups` (Technical Expertise Matrix)

Categorized technical skills with proficiency tags.

| Field | Type | Description |
| :--- | :--- | :--- |
| `categoryName` | String | Header (e.g., "Core Technologies", "Development Tools & Services"). |
| `description` | String | Sub-heading explaining the domain of these skills. |
| `skills` | Array of Objects or Strings | List of skills. Can be `{"name": "Dart", "level": "Expert"}` or `"Dart"`. |

**Proficiency levels supported:**
- `"Expert"` (Cyan glow)
- `"Advanced"` (Indigo glow)
- `"Experienced"` (Emerald glow)

**How to add a skill group:**
```json
{
  "categoryName": "Cloud & DevOps",
  "description": "Continuous integration, cloud functions, and infrastructure",
  "skills": [
    { "name": "Docker", "level": "Advanced" },
    { "name": "GitHub Actions CI/CD", "level": "Expert" },
    { "name": "Firebase Hosting & Cloud Run", "level": "Expert" }
  ]
}
```

---

### 7. `achievements` (Key Milestones & Enterprise Impact)

Highlight high-profile partnerships, leadership roles, or architectural milestones.

| Field | Type | Description |
| :--- | :--- | :--- |
| `title` | String | Achievement headline. |
| `description` | String | Detailed impact narrative. |
| `metricBadge` | String | Pill tag (e.g., "Walmart • DHL • BSE", "Quality & Mentorship"). |
| `iconName` | String | One of: `"corporate_fare"`, `"groups"`, `"design_services"`, `"shield"`, `"hub"`, `"verified"`. |

**Example:**
```json
{
  "title": "High-Volume Delivery",
  "description": "Delivered mission-critical mobile payment module processing over 500,000 transactions daily with 99.99% uptime.",
  "metricBadge": "500K Daily Transactions",
  "iconName": "hub"
}
```

---

### 8. `education` & `certifications`

```json
"education": [
  {
    "degree": "Bachelor of Science in Computer Science",
    "institution": "University of California, Berkeley",
    "year": "2018",
    "details": "Specialized in software systems, algorithms, and distributed networks."
  }
],
"certifications": [
  {
    "title": "AWS Certified Solutions Architect",
    "description": "Demonstrated expertise in designing scalable, highly available cloud systems.",
    "issuer": "Amazon Web Services",
    "credentialUrl": null
  }
]
```

---

### 9. `socialLinks` & `navigationItems`

#### `socialLinks`:
Configures icons in the footer and hero cards.
- `iconKey`: `"email"`, `"phone"`, `"github"`, `"linkedin"`, or `"link"`.
- `url`: The target link (e.g. `mailto:you@example.com`, `tel:+1234567890`, `https://github.com/username`).

#### `navigationItems`:
Menu links in the top navbar and mobile drawer.
- `label`: Title shown to users.
- `sectionKey`: Anchor identifier (`"about"`, `"experience"`, `"projects"`, `"skills"`, `"impact"`, `"education"`, `"contact"`).

---

## 🖼️ Adding Images and Assets

To add custom project thumbnails or profile photos:
1. Copy your `.png` or `.jpg` image into `assets/images/` (e.g., `assets/images/my_project.png`).
2. Reference the path in `portfolio.json`:
   ```json
   "profileImageUrl": "assets/images/my_photo.jpg"
   ```
3. Flutter is already configured to automatically load anything inside `assets/images/` and `assets/config/`.

---

## ⚡ Validating Your JSON

Before deploying, ensure:
1. All quotation marks and commas in `portfolio.json` are valid JSON syntax.
2. URLs start with `http://`, `https://`, `mailto:`, or `tel:`.
3. If an error occurs, the portfolio displays an explicit diagnostic message indicating which line/field needs correction.
