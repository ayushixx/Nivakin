// ============================================================
// pipeline/safety_interceptor.dart
// TIER 1 — Deterministic safety state machine.
// ZERO LLM dependency. Regex-only (<5ms execution limit). Must run first.
// Intercepts acute red flags: <1 hr pad soak, syncope/fainting, sharp unilateral pain.
// Routes to EMERGENCY_ESCALATION with Indian emergency channels.
// ============================================================

import '../models/nivakin_schema.dart';

class SafetyInterceptorResult {
  final bool isEmergency;
  final String? triggerReason;
  final List<EmergencyResource> resources;

  const SafetyInterceptorResult({
    required this.isEmergency,
    this.triggerReason,
    this.resources = const [],
  });
}

class EmergencyResource {
  final String name;
  final String number;
  final String description;
  final bool isDialable;

  const EmergencyResource({
    required this.name,
    required this.number,
    required this.description,
    this.isDialable = true,
  });
}

class SafetyInterceptor {
  SafetyInterceptor._();

  // ── Indian Emergency Resources ─────────────────────────────
  static const List<EmergencyResource> _indianEmergencyResources = [
    EmergencyResource(
      name: 'National Emergency',
      number: '112',
      description: 'Police, Fire & Medical Emergency Services',
    ),
    EmergencyResource(
      name: 'Childline India',
      number: '1098',
      description: '24×7 helpline for children and adolescents',
    ),
    EmergencyResource(
      name: 'Women\'s Helpline',
      number: '181',
      description: '24×7 Women in distress helpline',
    ),
    EmergencyResource(
      name: 'AFHC / RKSK Clinic',
      number: '104',
      description: 'Adolescent Friendly Health Centre — NHM Helpline',
    ),
  ];

  // ── Sub-5ms Deterministic Red-Flag Pattern Groups ──────────

  // 1. Heavy haemorrhage / < 1 hr pad soak rate
  static final List<RegExp> _heavyBleedingPatterns = [
    RegExp(r"soak(ing)?\s+(2\+?|two|3|three|multiple)\s+pad", caseSensitive: false),
    RegExp(r"pad\s+(every|within|in)\s+(less\s+than\s+)?(1|one|under\s+1)\s*hour", caseSensitive: false),
    RegExp(r"blood\s+clot", caseSensitive: false),
    RegExp(r"drench(ed|ing)", caseSensitive: false),
    RegExp(r"leak(ed|ing)?\s+(onto|through|on)\s+(clothes|sheet|underwear|bed)", caseSensitive: false),
    RegExp(r"changing\s+pad\s+(every|each)\s+(30|45|60|one|1)\s*(min|minute|hour)", caseSensitive: false),
    RegExp(r"bleed(ing)?\s+(non.?stop|doesn't\s+stop|very\s+heavy|too\s+much)", caseSensitive: false),
    RegExp(r"period\s+not\s+stopping", caseSensitive: false),
    // Hindi / Hinglish variants
    RegExp(r"khoon\s+(bahut|zyada|ruk\s+nahi)", caseSensitive: false),
    RegExp(r"bahut\s+(zyada|jyada)\s+(khoon|bleeding)", caseSensitive: false),
  ];

  // 2. Syncope / Loss of consciousness / Fainting
  static final List<RegExp> _syncopePatterns = [
    RegExp(r"faint(ed|ing)?", caseSensitive: false),
    RegExp(r"black(ed)?\s*out", caseSensitive: false),
    RegExp(r"pass(ed)?\s*out", caseSensitive: false),
    RegExp(r"los(t|ing)\s+consciousness", caseSensitive: false),
    RegExp(r"can't\s+(stand|walk|get\s+up)", caseSensitive: false),
    RegExp(r"cannot\s+(stand|walk|get\s+up)", caseSensitive: false),
    RegExp(r"dizzy\s+(and|&)\s+(bleed|faint)", caseSensitive: false),
    RegExp(r"chakkar\s+(aa|aya|aaya|aane)", caseSensitive: false),
    RegExp(r"behosh", caseSensitive: false),
  ];

  // 3. Acute sharp / unilateral abdominal pain
  static final List<RegExp> _severePainPatterns = [
    RegExp(r"unbearable\s+pain", caseSensitive: false),
    RegExp(r"screaming\s+(in\s+)?pain", caseSensitive: false),
    RegExp(r"worst\s+pain", caseSensitive: false),
    RegExp(r"pain\s+(is|was)\s+(10|ten)(\/10|\s*out\s*of\s*10)", caseSensitive: false),
    RegExp(r"(sharp|stabbing|shooting)\s+pain\s+(on\s+(one|left|right)\s+side)", caseSensitive: false),
    RegExp(r"can't\s+(breathe|move|straighten)", caseSensitive: false),
    RegExp(r"(right\s+side|left\s+side)\s+(pain|dard)\s+(sudden|sharp|acute)", caseSensitive: false),
    RegExp(r"dard\s+(bahut|bohot)\s+(zyada|jyada|tez)", caseSensitive: false),
    RegExp(r"dard\s+se\s+(rona|ro\s+rahi|tadap)", caseSensitive: false),
  ];

  // 4. Severe vomiting / dehydration risk
  static final List<RegExp> _severeVomitingPatterns = [
    RegExp(r"vomit(ing)?\s+(non.?stop|continu|can't\s+stop)", caseSensitive: false),
    RegExp(r"can't\s+(eat|drink|keep\s+(anything|food|water)\s+down)", caseSensitive: false),
    RegExp(r"dehydrat", caseSensitive: false),
    RegExp(r"ulti\s+(ho\s+rahi|ruk\s+nahi)", caseSensitive: false),
  ];

  // ── Primary Intercept Method ───────────────────────────────

  /// Runs synchronously in < 5ms. MUST be called before any LLM.
  /// Returns non-null triggerReason if an emergency is detected.
  static SafetyInterceptorResult check(String userInput) {
    final input = userInput.trim();

    // Check heavy bleeding
    for (final pattern in _heavyBleedingPatterns) {
      if (pattern.hasMatch(input)) {
        return const SafetyInterceptorResult(
          isEmergency: true,
          triggerReason: 'Very heavy bleeding detected (soaking through quickly) — please seek medical care immediately.',
          resources: _indianEmergencyResources,
        );
      }
    }

    // Check syncope
    for (final pattern in _syncopePatterns) {
      if (pattern.hasMatch(input)) {
        return const SafetyInterceptorResult(
          isEmergency: true,
          triggerReason: 'Fainting or loss of consciousness detected — this needs immediate medical evaluation.',
          resources: _indianEmergencyResources,
        );
      }
    }

    // Check severe pain
    for (final pattern in _severePainPatterns) {
      if (pattern.hasMatch(input)) {
        return const SafetyInterceptorResult(
          isEmergency: true,
          triggerReason: 'Severe or sharp unilateral pain detected — please visit a clinic or hospital right away.',
          resources: _indianEmergencyResources,
        );
      }
    }

    // Check severe vomiting / dehydration
    for (final pattern in _severeVomitingPatterns) {
      if (pattern.hasMatch(input)) {
        return const SafetyInterceptorResult(
          isEmergency: true,
          triggerReason: 'Unable to keep liquids down — please see a doctor today for hydration and care.',
          resources: _indianEmergencyResources,
        );
      }
    }

    return const SafetyInterceptorResult(isEmergency: false);
  }

  /// Also checks pad absorption level directly from UI selection
  static bool isPadLevelEmergency(PadAbsorptionLevel? level) {
    return level?.isHeavyBleeding ?? false;
  }
}
