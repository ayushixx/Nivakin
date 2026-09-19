# 🌸 Nivakin (निवाकिन) — Adolescent Health Navigator

[![Live App](https://img.shields.io/badge/🚀_Live_Demo-nivakin--health.vercel.app-F472B6?style=for-the-badge&logo=vercel)](https://nivakin-health.vercel.app/)
[![GitHub Repo](https://img.shields.io/badge/📦_GitHub-ayushixx%2FNivakin-C084FC?style=for-the-badge&logo=github)](https://github.com/ayushixx/Nivakin)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![On--Device Gemma](https://img.shields.io/badge/On--Device_AI-Gemma_2B_INT4-34D399?style=for-the-badge&logo=google)](https://ai.google.dev/gemma)

> **Privacy-first, zero-latency adolescent health companion & AI navigation engine for young girls (ages 11–18) in India.**  
> *Empowering girls through on-device offline intelligence, taboo refutations, WhatsApp elder scripts, and instantaneous privacy disguises.*

---

## 🔗 Quick Links
- 🌐 **Live Web Application:** [https://nivakin-health.vercel.app/](https://nivakin-health.vercel.app/)
- 📁 **GitHub Source Code:** [https://github.com/ayushixx/Nivakin](https://github.com/ayushixx/Nivakin)

---

## ⚡ Problem & The Nivakin Impact

120M+ teenage girls in South Asia experience menarche without private, taboo-free health guidance. Fear of stigma, lack of internet access, and disclosure anxiety prevent them from asking family members or seeking timely clinical advice.

### 🌟 5 Core Non-Negotiables
1. **Zero Diagnostic Speculation:** Never outputs disease labels (PCOS, endometriosis) or drug dosages. Grade 5–6 reading level orientation.
2. **On-Device Offline Gemma Engine:** Zero-latency Q&A via MediaPipe Gemma 2B INT4 and pre-cached developmental intent database. Zero server logs.
3. **3-Bucket Confidence Engine:** Structured output dividing results into **Lilac** (What We Know), **Blossom Pink** (What's Normal & Myths), and **Soft Amber** (Doctor Boundaries).
4. **"Baat Kaise Karein?" WhatsApp Sandbox:** Generates respectful scripts for Mummy, Didi, Doctor, and Warden in Hinglish, Hindi, and English.
5. **Quick Disguise Shield:** Instantly morphs the screen into an NCERT Class 10 Biology textbook cover and wipes sensitive form/chat memory from RAM.

---

## 📱 Multi-View Feature Matrix

| Feature | Description | Key Tech / Highlights |
| :--- | :--- | :--- |
| **🌸 Home Dashboard** | Greeting (`"Namaste, Betu 🌸"`), `"Offline Safe"` chip, 4 action cards & dynamic Myth of the Day card. | M3 Blossom Palette, 24px Pill Ergonomics |
| **💬 Offline Gemma Chat** | Interactive local Q&A with prompt pills (*"Why is my period brown?"*, *"Can I wash my hair?"*). | Zero-Latency On-Device Gemma / Intent Synthesizer |
| **🎯 Confidence Results** | 1-Sentence comforting verdict banner + 3 pastel cards (Known Facts, Biology & Myths, Doctor Boundaries). | Grounded JSON Schema Output (`temperature: 0.2`) |
| **📝 Baat Kaise Karein?** | WhatsApp message generator + practice comforting elder reply simulator. | Recipient Tabs (Mummy, Didi, Doctor, Warden) |
| **🩺 Doctor Prep Deck** | 1-Page summary card formatted for Adolescent Friendly Health Clinics (RKSK / AFHC). | Chief Concern, Daily Impact, 3 Doctor Questions |
| **📚 Quick Disguise** | Fullscreen NCERT Class 10 Biology camouflage with instant RAM cache purge. | Floral Top-Bar Panic Trigger |
| **🚨 Emergency Shield** | Deterministic sub-5ms red flag interceptor routing to national helplines. | 112 (Emergency), 1098 (Childline), 181 (Women) |

---

## 🛠️ Architecture & Tech Stack

```text
lib/
├── main.dart                       # Multi-View Router & Bottom Dock
├── theme/nivakin_theme.dart        # Blossom White (#FFF7F9), Rose Pink (#F472B6), Soft Lilac (#C084FC)
├── models/                         # Schema Contracts (3-Bucket, ExtractedSlots, ClinicianCard, OfflineFAQ)
├── pipeline/
│   ├── safety_interceptor.dart     # Deterministic Red-Flag Regex Check
│   ├── local_gemma_engine.dart     # On-Device Gemma 2B INT4 + Rule-Based Intent Parser
│   └── gemini_orchestrator.dart   # Official google_generative_ai SDK (Gemini 1.5 Flash)
└── views/                          # 8 Production-Grade Reactive Views
```

- **Frontend:** Flutter 3.x (Dart) with M3 Design Tokens
- **AI Pipelines:** Google MediaPipe LLM Inference Engine (Gemma 2B) + Google Generative AI SDK (`google_generative_ai: ^0.4.7`)
- **State Management:** Provider (`provider: ^6.1.2`)
- **Deployment:** Vercel Static Web Hosting (`vercel.json`)

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/ayushixx/Nivakin.git && cd Nivakin

# Install dependencies & run web
flutter pub get
flutter run -d chrome --web-port=8080

# Build release bundle
flutter build web --release
```

---

<p align="center">
  <b>Live Demo:</b> <a href="https://nivakin-health.vercel.app/">https://nivakin-health.vercel.app/</a><br>
  Made with 🌸 for young girls across the world.
</p>
