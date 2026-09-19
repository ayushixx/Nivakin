// ============================================================
// config/feature_flags.dart
// Toggle between On-Device Gemma 2B (MediaPipe) and Rule-Based
// Fallback Slot Parser based on platform and device capability.
// ============================================================

import 'package:flutter/foundation.dart';

class FeatureFlags {
  // ── Platform Guards ─────────────────────────────────────────
  // Gemma 2B INT4 via MediaPipe runs only on physical Android/iOS
  // devices with ≥3GB RAM. On Web (kIsWeb) or low-RAM conditions,
  // we transparently fall back to the deterministic rule-based parser.
  static bool get useOnDeviceGemma {
    if (kIsWeb) return false; // 1.5GB binary would freeze browser tab
    return _isNativeMobilePlatform;
  }

  static bool get _isNativeMobilePlatform {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // ── Gemini Cloud Orchestration ──────────────────────────────
  // Gemini 1.5 Flash for complex synthesis. Can be toggled off
  // for pure offline demo builds (e.g., hackathon without API key).
  static const bool useGeminiCloud = bool.fromEnvironment(
    'USE_GEMINI_CLOUD',
    defaultValue: true,
  );

  // ── Language Defaults ───────────────────────────────────────
  // Default script output language. 'hinglish' | 'hindi' | 'english'
  static const String defaultScriptLanguage = 'hinglish';

  // ── Safety Layer (ALWAYS ON — non-negotiable) ────────────────
  static const bool useDeterministicSafetyInterceptor = true;

  // ── Feature: Menarche-Aware Staging ─────────────────────────
  // Enables < 1-year menarche reassurance path in Card B.
  static const bool enableMenarcheStaging = true;

  // ── Feature: Pad Soak Rate Bleeding Detection ───────────────
  static const bool usePadSoakRateDetection = true;

  // ── Feature: WhatsApp Export ─────────────────────────────────
  static const bool enableWhatsAppExport = true;

  // ── Feature: Hostel / School Warden Script ──────────────────
  static const bool enableHostelWardenScript = true;

  // ── Quick Disguise ───────────────────────────────────────────
  static const bool enableQuickDisguise = true;
}
