# 🌸 Nivakin (निवाकिन) — Adolescent Health Navigator

> **Privacy-First, On-Device Offline Health Companion & AI Navigation Engine for Young Girls (Ages 11–18)**  
> *Built with Flutter, Google MediaPipe On-Device Gemma 2B, Gemini 1.5 Flash, and Indian Cultural Grounding.*

---

## 🏆 Hackathon Spotlight & Mission

**Nivakin** addresses a critical gap in adolescent healthcare across South Asia: over 120 million teenage girls experience menarche (first period) without accessible, taboo-free guidance. Fear of stigma, lack of private internet access, and disclosure anxiety often prevent them from seeking reassurance or communicating symptoms with family.

### 🌟 Core Non-Negotiable Tenets
1. **Zero Diagnostic Speculation:** Never outputs disease names (e.g., PCOS, Endometriosis) or drug dosages. Provides grounded orientation and clinical boundary preparation at a Grade 5–6 reading level.
2. **100% Private On-Device Gemma Engine:** Runs local zero-latency Q&A via MediaPipe Gemma 2B INT4 and pre-cached developmental intent database. Zero server logs.
3. **Reactive 8-Screen Architecture:** Seamless mobile navigation with bottom dock, status chips, dynamic myth busters, and 1-tap clinic summary pass.
4. **Cultural Grounding ("Baat Kaise Karein?"):** Generates respectful WhatsApp scripts in Hinglish, Hindi, and English for Mummy, Didi, Doctor, and Hostel Warden.
5. **Quick Disguise Shield:** Instantly morphs the UI into an NCERT Class 10 Biology textbook cover and wipes sensitive form/chat memory from RAM.

---

## 📱 App Views & Architecture

```text
lib/
├── main.dart                       # Reactive Router & M3 Bottom Navigation Dock
├── theme/
│   └── nivakin_theme.dart          # Blossom White (#FFF7F9), Rose Pink (#F472B6), Soft Lilac (#C084FC)
├── models/
│   ├── nivakin_schema.dart         # 3-Bucket contract, ExtractedSlots, ClinicianCard, ElderScripts
│   └── offline_faq_model.dart      # Suggested FAQ prompt pills & ChatMessage schema
├── pipeline/
│   ├── safety_interceptor.dart     # Deterministic red-flag check (<1 hr soak, syncope, sharp pain)
│   ├── local_gemma_engine.dart     # On-device Gemma 2B INT4 execution + Rule-based intent fallback
│   └── gemini_orchestrator.dart   # Official google_generative_ai SDK integration (temp: 0.2, JSON schema)
├── state/
│   └── nivakin_state.dart          # Provider state management & privacy RAM wiping
└── views/
    ├── home_dashboard_view.dart    # Dashboard: "Namaste, Betu 🌸", status chip, 4 cards, Myth of the Day
    ├── intake_view.dart            # Visual bubble chips, Hinglish voice/text input, menarche staging
    ├── confidence_view.dart        # 3-Bucket confidence results & WhatsApp script preview card
    ├── offline_gemma_chat_view.dart# Interactive on-device Gemma Q&A with suggested prompt pills
    ├── script_sandbox_view.dart    # "Baat Kaise Karein?" WhatsApp simulator for Mummy/Didi/Doctor/Warden
    ├── doctor_prep_view.dart       # 1-Page clinical summary card for RKSK / AFHC clinic visits
    ├── disguise_view.dart          # NCERT Class 10 Biology Chapter 8 camouflage shield
    └── emergency_view.dart         # Red-flag emergency card (112, 1098 Childline, 181, 104 AFHC)
```

---

## 💡 Key Features

### 1. 🌸 Home Dashboard (`home_dashboard_view.dart`)
- **Greeting & Connection Badge:** Displays `"Namaste, Betu 🌸"` and live `"Offline Safe (Local Gemma)"` indicator.
- **Quick-Action Cards:** One-tap navigation to Symptom Intake, Gemma Q&A, WhatsApp Script Sandbox, and Doctor Card.
- **Myth of the Day Micro-Card:** Dynamic buster refuting common Indian taboos (curd, pickles, hair washing, exercise).
- **Floral Panic Button:** Instantly activates NCERT Disguise Mode.

### 2. 💬 On-Device Offline Gemma Q&A (`offline_gemma_chat_view.dart`)
- **Zero-Latency Local Intelligence:** Functions completely without Wi-Fi or mobile data.
- **Suggested Prompt Pills:**
  - 🌸 *"Why is my period brown?"*
  - 🧼 *"Can I wash my hair during periods?"*
  - 🩸 *"How often should I change a pad?"*
  - 🏃‍♀️ *"What if I miss gym class?"*
  - 🍋 *"Can I eat pickles or curd during periods?"*

### 3. 🎯 3-Bucket Confidence Engine (`confidence_view.dart`)
- **Bucket A (What We Know - Lilac):** Confirmed user facts (age, symptoms, pain scale, duration).
- **Bucket B (What's Normal & Myths - Blossom Pink):** Anovulatory puberty cycles and explicit myth refutations.
- **Bucket C (Healthcare Boundaries - Soft Amber):** Clinical checkup boundaries without causing panic.

### 4. 📝 "Baat Kaise Karein?" Script Sandbox (`script_sandbox_view.dart`)
- **Recipient Tabs:** `[ Mummy ]`, `[ Didi / Sister ]`, `[ Doctor ]`, `[ School Teacher / Warden ]`.
- **Language Switcher:** `[ Hinglish ]`, `[ Hindi ]`, `[ Simple English ]`.
- **WhatsApp Simulator:** Realistic chat bubble styling, 1-tap Copy, and simulated comforting reply.

### 5. 🩺 Doctor Visit Card (`doctor_prep_view.dart`)
- 1-Page summary formatted for Indian clinics and RKSK / Adolescent Friendly Health Clinics (AFHC).
- Lists chief concern, duration, school absenteeism, remedies tried, and 3 specific doctor questions.

### 6. 📚 Quick Disguise Shield (`disguise_view.dart`)
- Camouflages the screen into **NCERT Class 10 Biology — Chapter 8: How do Organisms Reproduce?**.
- Purges input text controllers and intake memory from RAM upon activation.

---

## 🛠️ Tech Stack & Dependencies

- **Frontend Framework:** Flutter 3.x (Dart) with Material 3 Design Tokens
- **Design System:** Blossom White (`#FFF7F9`), Rose Pink (`#F472B6`), Soft Lilac (`#C084FC`), Soft Amber (`#F59E0B`), 24px Pill Ergonomics
- **Local AI Engine:** Google MediaPipe LLM Inference Engine (Gemma 2B INT4) + Rule-Based Intent Synthesizer
- **Cloud Orchestrator:** Google Generative AI SDK (`google_generative_ai: ^0.4.7`) — `Gemini 1.5 Flash` (Temp 0.2, JSON Schema Output)
- **State Management:** Provider (`provider: ^6.1.2`)
- **Typography:** Google Fonts Nunito (`google_fonts: ^6.2.1`)

---

## 🚀 Quick Start & Local Setup

```bash
# 1. Clone the repository
git clone https://github.com/ayushixx/Nivakin.git
cd Nivakin

# 2. Install dependencies
flutter pub get

# 3. Run on Flutter Web
flutter run -d chrome --web-port=8080

# 4. Build Production Web Bundle
flutter build web --release
```

---

## 🌐 Live Deployment & Vercel Setup

Nivakin is configured for 1-click deployment on **Vercel** via GitHub integration or Vercel CLI.

### Deploying to Vercel via CLI:
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

---

## 🔒 Privacy & Safety Compliance

- **No Medical Diagnoses:** Does not output medical labels or prescription drug dosages.
- **Zero Data Logging:** Offline Gemma Q&A operates purely in transient device memory.
- **Emergency Escalation:** Automatic deterministic detection (<1 hr pad soak, syncope, severe acute pain) instantly routes to:
  - 📞 **112** — National Emergency Response System
  - 📞 **1098** — Childline India
  - 📞 **181** — Women Helpline
  - 📞 **104** — Adolescent Friendly Health Clinic (AFHC) Helpline

---

<p align="center">Made with 🌸 for young girls across India & South Asia.</p>
